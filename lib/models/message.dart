import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String content;
  late String sender;
  late FieldValue timeStamp;
  late String conversationId;
  late String type;
  late String imageUrl;

  Message({
    required this.content,
    required this.sender,
    required this.timeStamp,
    required this.type,
    required this.conversationId,
  });

  Message.imageMessage({
    required this.content,
    required this.sender,
    required this.timeStamp,
    required this.type,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'content': this.content,
      'sender': this.sender,
      'time_stamp': this.timeStamp,
      'type': this.type,
      'conversation_id': this.conversationId,
    };
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.content = map['content'];
    this.sender = map['sender'];
    this.timeStamp = map['time_stamp'];
    this.type = map['type'];
    this.conversationId = map['conversation_id'];
  }
}
