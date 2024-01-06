import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/common/fonts.dart';
import 'package:flutter_web_portfolio/components/common/mouse_coordinator.dart';
import 'package:flutter_web_portfolio/constants/file_path.dart';
import 'package:flutter_web_portfolio/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Portfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey profileImageKey = GlobalKey();

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
            Text(
              'Flutter & Dart',
            ),
            Text(
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
            Image.asset(
              '$PHOTO/main_profile.jpg',
              key: profileImageKey,
              fit: BoxFit.contain,
              width: 1600 / 2,
              height: 900 / 2,
            ),
            TextField(
              onSubmitted: (value) async {
                await db.collection("textfield").add({"value": "$value"}).then(
                    (DocumentReference doc) =>
                        print('DocumentSnapshot added with ID: ${doc.id}'));
              },
            ),
            MouseCoordinator(
              childKey: profileImageKey,
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
