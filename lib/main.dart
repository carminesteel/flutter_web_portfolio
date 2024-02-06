import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/firebase_options.dart';
import 'package:flutter_web_portfolio/provider/action_provider.dart';
import 'package:flutter_web_portfolio/screens/main_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MainPage();
      },
      routes: <RouteBase>[
        // GoRoute(
        //   path: 'details',
        //   builder: (BuildContext context, GoRouterState state) {
        //     return const DetailsScreen();
        //   },
        // ),
      ],
    ),
  ],
);

//////////////////////////////////////////////////////////////////////////////

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context ){

    return MaterialApp.router(

      title: 'Flutter Web Portfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
      // home: ChangeNotifierProvider(
      //     create: (context) => ActionProvider(), child: MainPage()),
    );
  }
}
