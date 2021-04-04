import 'dart:async';

import 'package:WEdio/global_variables.dart';
import 'package:WEdio/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseHelper {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  auth.User? getCurrentUser() {
    auth.User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }
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

  Future<List<User>> getAllUsers(List chatList) async {
    List<User> users = [];
    for (var item in chatList) {
      var i = await _firestore.collection('users').doc(item).get();
      users.add(User.fromDocument(i));
    }
    // QuerySnapshot result = await _firestore.collection('users').get();
    // for (int i = 0; i < result.size; i++) {
    //   if (result.docs[i].id != currentUser!.uid) {
    //     users.add(User.fromDocument(result.docs[i]));
    //   }
    // }
    return users;
  }

  Future<List> getChatList(auth.User? currentUser) async {
    List chatList = [];
    QuerySnapshot res1 = await _firestore
        .collection('conversations')
        .where(
          'person1',
          isEqualTo: currentUser!.uid,
        )
        .get();
    QuerySnapshot res2 = await _firestore
        .collection('conversations')
        .where(
          'person2',
          isEqualTo: currentUser.uid,
        )
        .get();
    res1.docs.forEach((element) {
      chatList.add(element.data()?['person2']);
    });
    res2.docs.forEach((element) {
      chatList.add(element.data()?['person1']);
    });

    return chatList;
  }
}
