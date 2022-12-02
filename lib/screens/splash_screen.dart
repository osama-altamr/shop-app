import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/auth.dart';
import '../screens/product_overview_screen.dart';
import 'auth_screen/login.dart';
import 'navigation_screen/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = '/splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: EasySplashScreen(
          logo: Image.asset(
            'assets/images/splash-images/shop-logo.png',
            scale: 2,
          ),
          title: const Text(
            "Shopping",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          // backgroundColor: Colors.white,
          gradientBackground: LinearGradient(colors: [
            Colors.purple,
            Colors.deepOrange,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          loaderColor: Colors.white,
          showLoader: true,
          loadingText: const Text("Loading..."),
          navigator: Consumer<Auth>(builder: (ctx, valueAuth, _) {
            return valueAuth.isAuth
                ? MyApp()
                : FutureBuilder(
                    future: valueAuth.tryAutoLogin(),
                    builder: (_, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting)
                        return CircularProgressIndicator();
                      else {
                        return LoginScreen();
                      }
                    });
          }),
          durationInSeconds: 3,
        ),
      ),
    );
  }
}
