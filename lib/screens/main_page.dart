import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/common/fonts.dart';
import 'package:flutter_web_portfolio/components/interactive_widget.dart';
import 'package:flutter_web_portfolio/components/mouse_coordinator.dart';

import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Size get screen => MediaQuery.of(context).size;
  bool clicked = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: screen.width,
        height: screen.height,
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
              color: Colors.white,
            )),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              onEnd: () {},
              curve: Curves.easeOutCirc,
              left: clicked ? 120 : 600,
              top: clicked ? 100 : 300,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        clicked = !clicked;
                      });
                    },
                    child: Center(
                      child: InteractiveWidget(),
                    ),
                  ),
                  _title()
                ],
              ),
            )
          ],
        ),
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
