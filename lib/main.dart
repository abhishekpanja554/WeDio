// import 'dart:io';
// import 'package:WEdio/Screens/chat_page.dart';
import 'package:WEdio/backend/firebase_helper.dart';
import 'package:WEdio/backend/signalling.service.dart';
import 'package:WEdio/global_variables.dart';
import 'package:WEdio/helpers/route_helper.dart';
import 'package:WEdio/providers/image_message_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
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
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      SignallingService.instance.init(
        websocketUrl: websocketUrl,
        selfCallerID: FirebaseHelper().getCurrentUser()!.uid,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageMessageProvider>(
      create: (context) => ImageMessageProvider(),
      child: InAppNotification(
        child: MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          title: 'WEdio',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
        ),
      ),
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
