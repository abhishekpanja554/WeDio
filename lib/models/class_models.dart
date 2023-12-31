// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:WEdio/models/user.dart';

class CallScreenArgs {
  String calleeId;
  String calleeName;
  String callerId;
  dynamic offer;
  Key? key;
  CallScreenArgs({
    required this.calleeId,
    required this.calleeName,
    required this.callerId,
    this.offer,
    this.key,
  });
  // CallScreenArgs({
  //   required this.calleeId,
  //   required this.calleeName,
  //   required this.callerId,
  //   this.offer,
  //   this.key,
  // });

  // Map<String, dynamic> toJson() {
  //   return <String, dynamic>{
  //     'calleeId': calleeId,
  //     'calleeName': calleeName,
  //     'callerId': callerId,
  //     'offer': offer,
  //   };
  // }

  // factory CallScreenArgs.fromJson(Map<String, dynamic> map) {
  //   return CallScreenArgs(
  //     calleeId: map['calleeId'] as String,
  //     calleeName: map['calleeName'] as String,
  //     callerId: map['callerId'] as String,
  //     offer: map['offer'] as dynamic,
  //     key: map['key'] != null ? map['key'] as Key : null,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'calleeId': calleeId,
      'calleeName': calleeName,
      'callerId': callerId,
      'offer': offer,
      'key': key,
    };
  }

  factory CallScreenArgs.fromMap(Map<String, dynamic> map) {
    return CallScreenArgs(
      calleeId: map['calleeId'] as String,
      calleeName: map['calleeName'] as String,
      callerId: map['callerId'] as String,
      offer: map['offer'] != null ? map['offer'] as dynamic : null,
      key: map['key'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CallScreenArgs.fromJson(String source) => CallScreenArgs.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ChatPageArgs {
  User? chatParticipant;
  String conversationId;
  ChatPageArgs({
    this.chatParticipant,
    required this.conversationId,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatParticipant': chatParticipant?.toMap(),
      'conversationId': conversationId,
    };
  }

  factory ChatPageArgs.fromMap(Map<String, dynamic> map) {
    return ChatPageArgs(
      chatParticipant: map['chatParticipant'] != null ? User.fromMap(map['chatParticipant'] as Map<String,dynamic>) : null,
      conversationId: map['conversationId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatPageArgs.fromJson(String source) => ChatPageArgs.fromMap(json.decode(source) as Map<String, dynamic>);
}
