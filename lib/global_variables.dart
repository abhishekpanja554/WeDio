// import 'package:contacts_service/contacts_service.dart';

import 'package:flutter_contacts/flutter_contacts.dart';

List chatList = [];
List<Map<String, dynamic>> usersList = [];
List<Contact> contacts = [];
const String websocketUrl = "https://webrtc-signalling-gpn6.onrender.com";
String? fcmToken;
dynamic incomingSDPOffer;
