import 'package:WEdio/Screens/home_page.dart';
// import 'package:WEdio/Screens/login_page.dart';
import 'package:WEdio/widgets/custom_loading.dart';
import 'package:WEdio/widgets/custom_textField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupPage extends StatefulWidget {
  static const String id = 'signuppage';
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _animation;
  late Animation<Offset> _animation2;
  late AnimationController _animationController;
  Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  Tween<Offset> _offset2 = Tween(begin: Offset(-1, 0), end: Offset(0, 0));

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();

  double profileIconPos = -150;

  void signUp() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CustomLoading();
        });

    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((ex) {
      Navigator.pop(context);
      FirebaseAuthException thisEx = ex;
      ScaffoldMessenger.maybeOf(context)!.showSnackBar(SnackBar(
        content: Text(thisEx.message!),
      ));
    });

    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');
    userRef.doc('${userCredential.user!.uid}').set({
      'fullname': fullnameController.text,
      'email': emailController.text,
      'gender': genderController.text,
      'phone': phoneController.text,
    });

    Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _animation = _offset.animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
    ));
    _animation2 = _offset2.animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
    ));
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        profileIconPos = 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          //upper portion
          Positioned(
            top: 0,
            child: Container(
              height: mediaQuery.size.height,
              width: mediaQuery.size.width,
              color: Color(0xFF0059D4),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 40, top: 10),
                    alignment: Alignment.topRight,
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Quicksand-SemiBold',
                        fontSize: 25,
                      ),
                    ),
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
                        height: mediaQuery.size.height * 0.95,
                        width: mediaQuery.size.width,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: mediaQuery.size.width,
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                        ),
                        Container(
                          height: 140,
                          width: 140,
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                curve: Curves.easeInOutQuad,
                                duration: Duration(
                                  milliseconds: 500,
                                ),
                                top: profileIconPos,
                                child: CircleAvatar(
                                  radius: 70,
                                  child: Image.asset(
                                    'images/profile-logo.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SlideTransition(
                          position: _animation,
                          child: Container(
                            height: 50,
                            width: 300,
                            child: CustomTextField(
                              controller: fullnameController,
                              hintAndLabelText: 'Full Name',
                              prefixIcon: Icons.person_outline,
                              keynoardType: TextInputType.name,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SlideTransition(
                          position: _animation2,
                          child: Container(
                            height: 50,
                            width: 300,
                            child: CustomTextField(
                              controller: phoneController,
                              hintAndLabelText: 'Phone',
                              prefixIcon: Icons.phone_outlined,
                              keynoardType: TextInputType.phone,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SlideTransition(
                          position: _animation,
                          child: Container(
                            height: 50,
                            width: 300,
                            child: CustomTextField(
                              hintAndLabelText: 'Gender',
                              prefixIcon: FontAwesomeIcons.venusMars,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SlideTransition(
                          position: _animation2,
                          child: Container(
                            height: 50,
                            width: 300,
                            child: CustomTextField(
                              controller: emailController,
                              hintAndLabelText: 'Email',
                              prefixIcon: Icons.email_outlined,
                              keynoardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SlideTransition(
                          position: _animation,
                          child: Container(
                            height: 50,
                            width: 300,
                            child: CustomTextField(
                              controller: passwordController,
                              hintAndLabelText: 'Password',
                              prefixIcon: Icons.lock_outline,
                              obscureText: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //sign up button
                        GestureDetector(
                          onTap: signUp,
                          child: Hero(
                            tag: 'signup',
                            child: Container(
                              alignment: Alignment.center,
                              height: 60,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Color(0xFF0059D4),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                border:
                                    Border.all(color: Colors.white, width: 3),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Hero(
                            tag: 'login',
                            child: Container(
                              alignment: Alignment.center,
                              height: 60,
                              width: 250,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
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
                                'LOG IN',
                                style: TextStyle(
                                  color: Color(0xFF0059D4),
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
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 50);
    path.quadraticBezierTo(size.width * (3 / 4), 100, size.width, 50);
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
