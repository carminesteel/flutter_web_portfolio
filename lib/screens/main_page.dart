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
  // firebase 구현필요
  final db = FirebaseFirestore.instance;

  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InteractiveWidget(),
            // InteractiveWidget(globalKey: _profileImageKey),
            TextField(
              onSubmitted: (value) async {
                await db.collection("textfield").add({"value": "$value"}).then(
                    (DocumentReference doc) =>
                        print('DocumentSnapshot added with ID: ${doc.id}'));
              },
            ),
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
