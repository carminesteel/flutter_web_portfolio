import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/common/fonts.dart';
import 'package:flutter_web_portfolio/common/utils.dart';
import 'package:flutter_web_portfolio/components/interactive_widget.dart';
import 'package:flutter_web_portfolio/components/mouse_coordinator.dart';

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
  Offset _widgetCenterOffset = const Offset(0, 0);

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

  void _setCenterOffset() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (profileImageKey.globalPaintBounds != null) {
        _widgetCenterOffset = profileImageKey.globalPaintBounds!.center;
      }
    });
  }

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
        onPositionChange: (offset) {
          x = ((_widgetCenterOffset - offset).dy) / 1000;
          y = ((_widgetCenterOffset - offset).dx) / 1000;
        },
        child: Center(
            child: AnimatedScale(
          scale: isHover ? 1.2 : 1.0,
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
