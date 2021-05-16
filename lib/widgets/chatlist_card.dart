import 'package:WEdio/backend/firebase_helper.dart';
import 'package:WEdio/backend/utility_class.dart';
import 'package:WEdio/models/user.dart';
import 'package:flutter/material.dart';

class ChatListCard extends StatelessWidget {
  final User? chatUser;
  final String lastMessage;
  final bool isMe;

  UtilityClass _utilityClass = UtilityClass();

  ChatListCard({
    required this.chatUser,
    required this.lastMessage,
    required this.isMe,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color(0xFF2A57A0),
                Color(0xFF1F4385),
              ],
              stops: [
                0,
                0.5,
                1,
              ],
            ),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent,
                blurRadius: 15,
                spreadRadius: -10,
                offset: Offset(-5, -3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1F4385),
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  colors: [
                    Color(0xFF244E91),
                    Color(0xFF2A57A0),
                    Color(0xFF244E91),
                    Color(0xFF1F4385),
                  ],
                  stops: [
                    0,
                    0.3,
                    0.6,
                    1,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Container(
                          height: 50,
                          width: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            _utilityClass.getInitials(chatUser!.fullname),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'Quicksand-SemiBold',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                chatUser!.fullname,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(
                                lastMessage,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.blueGrey.shade100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
