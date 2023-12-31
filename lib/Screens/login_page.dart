
import 'package:WEdio/Screens/home_page.dart';
import 'package:WEdio/Screens/signip_page.dart';
import 'package:WEdio/backend/firebase_helper.dart';
import 'package:WEdio/widgets/custom_loading.dart';
import 'package:WEdio/widgets/custom_textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  static const String id = '/loginpage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseHelper _helper = FirebaseHelper();

  void login() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomLoading();
        });

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((ex) {
      context.pop();
      FirebaseAuthException thisEx = ex;
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
        content: Text(thisEx.message!),
      ));
    });

    await _helper.deleteTable();

    Database db = await _helper.createContactDb();

    await _helper.updateContacts(context);
    // List<User> contactsList = [];
    await _helper.getAllAvailableCOntacts().then((value) {
      value.forEach((element) async {
        if (_helper.getCurrentUser()!.uid != element.uid) {
          await _helper.insertContactIntoDb(
              db, element.uid, element.fullname, element.phone);
        }
      });
      context.pop();
      context.go(HomePage.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: [
          //upper portion
          Positioned(
            top: 0,
            child: Container(
              height: mediaQuery.size.height,
              width: mediaQuery.size.width,
              color: Color(0xFF0059D4),
              //logo and title
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 16,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'images/app_logo.png',
                      height: 100,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Quicksand-SemiBold',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'WEdio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontFamily: 'Quicksand-Bold',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Messenger',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Quicksand-Light',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          //lower portion
          Positioned(
            bottom: 0,
            child: Stack(
              children: [
                CustomPaint(
                  painter: ClipShadowShadowPainter(),
                  child: ClipPath(
                    clipper: MyClipper(),
                    child: Hero(
                      tag: 'lower_portion',
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Color(0xFF006BFF),
                        ),
                        height: mediaQuery.size.height * 0.5,
                        width: mediaQuery.size.width,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: mediaQuery.size.width,
                  padding: EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 85,
                      ),
                      Container(
                        height: 50,
                        // width: 300,
                        child: CustomTextField(
                          controller: emailController,
                          hintAndLabelText: 'Email',
                          prefixIcon: Icons.email_outlined,
                          keynoardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        // width: 300,
                        child: CustomTextField(
                          controller: passwordController,
                          hintAndLabelText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      //login button
                      GestureDetector(
                        onTap: login,
                        child: Hero(
                          tag: 'login',
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              border: Border.all(
                                color: Colors.black38,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 16,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Color(0xFF0059D4),
                                  fontFamily: 'Quicksand-Bold',
                                  fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 60,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Divider(
                                  color: Colors.white,
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Container(
                                child: Divider(
                                  color: Colors.white,
                                  height: 1,
                                  thickness: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      //sign up button
                      GestureDetector(
                        onTap: () {
                          context.push(SignupPage.id);
                        },
                        child: Hero(
                          tag: 'signup',
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Color(0xFF0059D4),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              ),
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 16,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'SIGH UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Quicksand-Bold',
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//clipper path for lower container
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 50);
    path.quadraticBezierTo(size.width / 4, 100, size.width / 2, 50);
    path.quadraticBezierTo(size.width * (3 / 4), 0, size.width, 50);
    path.lineTo(size.width, 50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

//custom painter class for shadow effect of lower container
class ClipShadowShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    MyClipper clipper = MyClipper();
    Shadow shadow = Shadow(
      blurRadius: 16,
      color: Color(0xFF006BFF),
      offset: Offset(0, -4),
    );
    Paint paint = shadow.toPaint();
    Path clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
