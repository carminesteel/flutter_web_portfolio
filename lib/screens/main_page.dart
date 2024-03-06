import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/common/fonts.dart';
import 'package:flutter_web_portfolio/common/utils.dart';
import 'package:flutter_web_portfolio/components/interactive_widget.dart';
import 'package:flutter_web_portfolio/components/mouse_coordinator.dart';
import 'package:flutter_web_portfolio/provider/action_provider.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  Size get screen => MediaQuery.of(context).size;
  bool clicked = false;
  GlobalKey profileImageKey = GlobalKey();
  Offset _widgetCenterOffset = Offset.zero;

  double x = 0;
  double y = 0;
  bool isHover = false;

  // firebase 구현필요
  //////////////////////////////////////////////////////////////////////////////
  final db = FirebaseFirestore.instance;

  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };
  //////////////////////////////////////////////////////////////////////////////

  _textfield() {
    return TextField(
      onSubmitted: (value) async {
        await db.collection("textfield").add({"value": "$value"}).then(
            (DocumentReference doc) =>
                print('DocumentSnapshot added with ID: ${doc.id}'));
      },
    );
  }

  Widget _title() {
    return Padding(
      padding: EdgeInsets.only(top: 70),
      child: Row(
        children: [
          SelectableText(
            'Flutter & Dart',
          ),
          SelectableText(
            '개발자 김홍철입니다. :)',
            style: CustomFont.noto,
          )
        ],
      ),
    );
  }

  // 중간에 사용자가 창의 크기를 변경하는 경우 중앙 지점의 오프셋을 다시 계산하기 위함.
  void _setCenterOffset() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (profileImageKey.globalPaintBounds != null) {
        _widgetCenterOffset = profileImageKey.globalPaintBounds!.center;
      }
    });
  }

  // 최초 실행시 중앙값 초기화.
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _setCenterOffset();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Metrics 의 변동을 감지하면 함수 실행.
  @override
  void didChangeMetrics() {
    _setCenterOffset();
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MouseCoordinator(
        onMouseHover: () {
          // 마우스가 올려져 있는 동안 일정 영역 내에 진입한 경우 상태 변경
          if (x.abs() < 0.2 && y.abs() < 0.2) {
            setState(() {
              isHover = true;
            });
          } else {
            setState(() {
              isHover = false;
            });
          }
        },
        // 마우스 포지션이 변경되면 위젯의 기울기를 즉각적으로 변경시키기 위함.
        onPositionChange: (offset) {
          x = ((_widgetCenterOffset - offset).dy) / 1000;
          y = ((_widgetCenterOffset - offset).dx) / 1000;
        },
        child: Center(
            child: AnimatedScale(
          scale:
              // 마우스가 호버링중이거나 클릭을 한 상태면 스케일링 실행.
              isHover || context.read<ActionProvider>().isTriggered ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: InteractiveWidget(
            x: x,
            y: y,
            profileImageKey: profileImageKey,
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await db.collection("users").add(user).then((DocumentReference doc) =>
              print('DocumentSnapshot added with ID: ${doc.id}'));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
