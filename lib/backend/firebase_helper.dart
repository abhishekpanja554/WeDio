import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseHelper {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User? getCurrentUser() {
  //   User? currentUser;
  //   currentUser = _auth.currentUser;
  //   return currentUser;
  // }
  // Future<UserCredential> signIn() async {
  //   GoogleSignInAccount _signInAcc = await (_googleSignIn.signIn() as FutureOr<GoogleSignInAccount>);
  //   GoogleSignInAuthentication _signInAuth = await _signInAcc.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: _signInAuth.accessToken,
  //     idToken: _signInAuth.idToken,
  //   );
  //   UserCredential user = await _auth.signInWithCredential(credential);
  //   return user;
  // }

  // Future<bool> authenticateUser(UserCredential user) async {
  //   QuerySnapshot result = await _firestore
  //       .collection("users")
  //       .where("email", isEqualTo: user.user!.email)
  //       .get();

  //   final List<DocumentSnapshot> docs = result.docs;

  //   return docs.length == 0 ? true : false;
  // }
}
