import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/firebase_options.dart';
import 'package:flutter_web_portfolio/provider/action_provider.dart';
import 'package:flutter_web_portfolio/screens/main_page.dart';
import 'package:flutter_web_portfolio/screens/profile_screen.dart';
import 'package:flutter_web_portfolio/util/transition.dart';
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
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return ChangeNotifierProvider(
            create: (context) => ActionProvider(), child: MainPage());
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'profile',
          name : 'profile',
          pageBuilder: (context, state) => buildPageWithoutTransition(
            context: context,
            state: state,
            child: const ProfileScreen(),
          ),

        ),
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
