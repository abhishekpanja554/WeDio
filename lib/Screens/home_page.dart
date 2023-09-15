import 'package:WEdio/Screens/tab_pages/contacts_tab.dart';
import 'package:WEdio/Screens/tab_pages/home_tab.dart';
import 'package:WEdio/backend/firebase_helper.dart';
import 'package:WEdio/backend/signalling.service.dart';
import 'package:WEdio/global_variables.dart';
import 'package:WEdio/widgets/inapp_notification_body.dart';
import 'package:dio/dio.dart';
// import 'package:WEdio/backend/firebase_helper.dart';
// import 'package:WEdio/global_variables.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:in_app_notification/in_app_notification.dart';

class HomePage extends StatefulWidget {
  static const String id = '/homepage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController pageController;
  String appBarTitle = 'Chat';
  int _currentPage = 0;
  FirebaseHelper _helper = FirebaseHelper();

  @override
  void initState() {
    _helper.updateContacts(context);
    pageController = PageController();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // SignallingService.instance.init(
      //   websocketUrl: websocketUrl,
      //   selfCallerID: FirebaseHelper().getCurrentUser()!.uid,
      // );
      // listen for incoming video call
      SignallingService.instance.socket!.on("newCall", (data) {
        if (mounted) {
          // set SDP Offer of incoming call
          setState(() {
            incomingSDPOffer = data;
          });
          InAppNotification.show(
            duration: Duration(minutes: 100),
            child: NotificationBody(),
            context: context,
            onTap: () => print('Notification tapped!'),
          );
        }
      });
    });
    super.initState();
  }

  void onPageChanged(newPage) {
    setState(() {
      _currentPage = newPage;
    });
    changeAppbarTitle();
  }

  void onTabChanged(newPage) {
    setState(() {
      _currentPage = newPage;
      pageController.animateToPage(
        newPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
    changeAppbarTitle();
  }

  void changeAppbarTitle() {
    if (_currentPage == 0) {
      setState(() {
        appBarTitle = 'Chat';
      });
    } else if (_currentPage == 1) {
      setState(() {
        appBarTitle = 'Calls';
      });
    } else if (_currentPage == 2) {
      setState(() {
        appBarTitle = 'Contacts';
      });
    } else if (_currentPage == 3) {
      setState(() {
        appBarTitle = 'Settings';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      floatingActionButton: FloatingActionButton(onPressed: () async {
        final Dio _dio = Dio();
        final _baseUrl = 'http://192.168.29.245:3000/send_notification';
        Response userData = await _dio.post(_baseUrl, data: {
          "fcmToken": fcmToken,
        });
      }),
      appBar: AppBar(
        elevation: 15,
        toolbarHeight: 70,
        leading: Container(
          padding: EdgeInsets.only(left: 20),
          child: Image.asset(
            'images/Wedio_logo2.png',
            width: 50,
            height: 50,
            fit: BoxFit.fitWidth,
          ),
        ),
        leadingWidth: 80,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          appBarTitle,
          style: TextStyle(
            fontFamily: 'Quicksand-SemiBold',
            fontSize: 30,
            color: Color(0xFF005DAF),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          HomeTab(),
          Center(
            child: Text(
              "Call Logs",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ContactTab(),
          Center(
            child: Text(
              "Settings",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 2,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF005DAF),
          unselectedItemColor: Colors.blueGrey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.chat_bubble_fill),
              icon: Icon(
                CupertinoIcons.chat_bubble,
                size: 30,
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.phone_fill),
              icon: Icon(
                CupertinoIcons.phone,
                size: 30,
              ),
              label: 'Calls',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.person_alt_circle_fill),
              icon: Icon(
                CupertinoIcons.person_alt_circle,
                size: 30,
              ),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.gear_alt_fill),
              icon: Icon(
                CupertinoIcons.gear_alt,
                size: 30,
              ),
              label: 'Settings',
            ),
          ],
          currentIndex: _currentPage,
          onTap: onTabChanged,
        ),
      ),
    );
  }
}
