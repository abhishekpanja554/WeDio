import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String uid;
  late String fullname;
  late String email;
  late String phone;
  late String gender;

  User({
    required this.uid,
    required this.email,
    required this.fullname,
    required this.gender,
    required this.phone,
  });

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.fullname = mapData['fullname'];
    this.gender = mapData['gender'];
    this.phone = mapData['phone'];
  }

  User.fromDocument(DocumentSnapshot<Map> doc) {
    this.uid = doc.id;
    this.email = doc.data()?['email'];
    this.fullname = doc.data()?['fullname'];
    this.gender = doc.data()?['gender'];
    this.phone = doc.data()?['phone'];
  }

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['fullname'] = user.fullname;
    data['email'] = user.email;
    data['gender'] = user.gender;
    data['phone'] = user.phone;
    return data;
  }
}
