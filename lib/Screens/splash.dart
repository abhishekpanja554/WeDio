import 'package:WEdio/Screens/home_page.dart';
import 'package:WEdio/Screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  checkLogin() async {
    Future.delayed(Duration(seconds: 1), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.id, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, LoginPage.id, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/app_logo.png',
          height: 100,
        ),
      ),
    );
  }
}
