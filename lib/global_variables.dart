// import 'package:contacts_service/contacts_service.dart';

import 'package:flutter_contacts/flutter_contacts.dart';

List chatList = [];
List<Map<String, dynamic>> usersList = [];
late List<Contact> contacts;
const String websocketUrl = "http://52.66.210.196:5000";
String? fcmToken;
dynamic incomingSDPOffer;
