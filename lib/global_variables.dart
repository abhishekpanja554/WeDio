// import 'package:contacts_service/contacts_service.dart';

import 'package:flutter_contacts/flutter_contacts.dart';

List chatList = [];
List<Map<String, dynamic>> usersList = [];
late List<Contact> contacts;
const String websocketUrl = "http://13.233.128.35:5000";
String? fcmToken;