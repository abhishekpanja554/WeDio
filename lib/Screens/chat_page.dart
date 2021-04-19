import 'package:WEdio/models/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chatpage';
  final User chatParticipant;

  ChatPage({required this.chatParticipant});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F4385),
      appBar: AppBar(
        centerTitle: true,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xFF005DAF),
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        elevation: 15,
        toolbarHeight: 70,
        title: Row(
          children: [
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            //   child: Container(
            //     height: 65,
            //     width: 65,
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: Colors.blue.shade900,
            //         width: 2,
            //       ),
            //       color: Colors.blueAccent,
            //       shape: BoxShape.circle,
            //     ),
            //     child: Text(
            //       'AP',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 30,
            //         fontFamily: 'Quicksand-SemiBold',
            //       ),
            //     ),
            //   ),
            // ),
            Text(
              widget.chatParticipant.fullname,
              style: TextStyle(
                color: Color(0xFF005DAF),
                fontFamily: 'Quicksand-SemiBold',
                fontSize: 26,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width) * 0.8,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 17,
                  ),
                  Container(
                    width: (MediaQuery.of(context).size.width) * 0.125,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      FontAwesomeIcons.solidPaperPlane,
                      color: Color(0xFF5775A0),
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
