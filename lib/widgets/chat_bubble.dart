import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(top: 12),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: messageRadius,
                    bottomLeft: messageRadius,
                  )
                : BorderRadius.only(
                    topRight: messageRadius,
                    bottomRight: messageRadius,
                  ),
          ),
          child: Container(
            margin: isMe
                ? EdgeInsets.only(
                    bottom: 5,
                    right: 15,
                    top: 5,
                    left: 5,
                  )
                : EdgeInsets.only(
                    bottom: 5,
                    right: 5,
                    top: 5,
                    left: 15,
                  ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.shade600,
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
