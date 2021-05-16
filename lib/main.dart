// import 'dart:io';
// import 'package:WEdio/Screens/chat_page.dart';
import 'package:WEdio/Screens/signip_page.dart';
import 'package:WEdio/providers/image_message_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Screens/home_page.dart';
import 'Screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // FirebaseRepo _repo = FirebaseRepo();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageMessageProvider>(
      create: (context) => ImageMessageProvider(),
      child: MaterialApp(
        title: 'WEdio',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: LoginPage.id,
        routes: {
          HomePage.id: (context) => HomePage(),
          LoginPage.id: (context) => LoginPage(),
          SignupPage.id: (context) => SignupPage(),
        },
      ),
    );
  }
}
