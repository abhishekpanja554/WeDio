// import 'dart:io';
// import 'package:WEdio/Screens/chat_page.dart';
import 'package:WEdio/Screens/signip_page.dart';
import 'package:WEdio/Screens/splash.dart';
import 'package:WEdio/global_variables.dart';
import 'package:WEdio/providers/image_message_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';

import 'Screens/home_page.dart';
import 'Screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'wideo',
    options: FirebaseOptions(
        apiKey: "qvG5wCyAnx3Fwhx83ZhpuJYf0ZGh8",
        appId: "1:307789734463:android:500f9741cd68f02b758e8a",
        messagingSenderId: '307789734463',
        projectId: "wedio-fb1c2"),
  );
  fcmToken = await FirebaseMessaging.instance.getToken();
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
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
      child: InAppNotification(
        child: MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'WEdio',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: SplashScreen.id,
          routes: {
            HomePage.id: (context) => HomePage(),
            LoginPage.id: (context) => LoginPage(),
            SignupPage.id: (context) => SignupPage(),
            SplashScreen.id: (context) => SplashScreen(),
          },
        ),
      ),
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
