import 'package:WEdio/widgets/cached_image.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String date;
  final bool isRead;
  final String type;

  final String url;
  ChatBubble({
    required this.message,
    required this.isMe,
    required this.time,
    required this.date,
    required this.type,
    this.isRead = false,
    this.url = '',
  });

  @override
  Widget build(BuildContext context) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 3,
      ),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 7),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
              minWidth: 60,
            ),
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
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth:
                            (MediaQuery.of(context).size.width * 0.75) - 25,
                        minWidth: 60,
                      ),
                      margin: isMe
                          ? EdgeInsets.only(
                              bottom: 0,
                              right: 3,
                              top: 5,
                              left: 5,
                            )
                          : EdgeInsets.only(
                              bottom: 0,
                              right: 5,
                              top: 5,
                              left: 10,
                            ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isMe ? Colors.blue.shade600 : Colors.green,
                      ),
                      child: type == 'text'
                          ? Text(
                              message,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          : CachedImage(url: url),
                    ),
                    isMe
                        ? Container(
                            height: 5,
                            width: 5,
                            margin: EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              color: isRead ? Colors.green : Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                Container(
                  margin: isMe
                      ? EdgeInsets.only(left: 10)
                      : EdgeInsets.only(right: 10),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Container(
            margin: isMe ? EdgeInsets.only(right: 5) : EdgeInsets.only(left: 5),
            child: Text(
              date,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
