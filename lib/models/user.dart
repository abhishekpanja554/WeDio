// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String fullname;
  String email;
  String phone;
  String gender;
  User({
    required this.uid,
    required this.fullname,
    required this.email,
    required this.phone,
    required this.gender,
  });

  // User({
  //   required this.uid,
  //   required this.email,
  //   required this.fullname,
  //   required this.gender,
  //   required this.phone,
  // });

  // User.fromJson(Map<String, dynamic> mapData) {
  //   this.uid = mapData['uid'];
  //   this.email = mapData['email'];
  //   this.fullname = mapData['fullname'];
  //   this.gender = mapData['gender'];
  //   this.phone = mapData['phone'];
  // }

  factory User.fromDocument(DocumentSnapshot<Map> doc) {
    return User(
      uid: doc.id,
      email: doc.data()?['email'],
      fullname: doc.data()?['fullname'],
      gender: doc.data()?['gender'],
      phone: doc.data()?['phone'],
    );
  }

  // Map toJson(User user) {
  //   var data = Map<String, dynamic>();
  //   data['uid'] = user.uid;
  //   data['fullname'] = user.fullname;
  //   data['email'] = user.email;
  //   data['gender'] = user.gender;
  //   data['phone'] = user.phone;
  //   return data;
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'phone': phone,
      'gender': gender,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      fullname: map['fullname'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      gender: map['gender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
