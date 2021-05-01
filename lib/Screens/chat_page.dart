import 'package:WEdio/backend/firebase_helper.dart';
import 'package:WEdio/models/message.dart';
import 'package:WEdio/models/user.dart';
import 'package:WEdio/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatPage extends StatefulWidget {
  static const String id = 'chatpage';
  final User? chatParticipant;
  final String conversationId;

  ChatPage({required this.chatParticipant, required this.conversationId});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _animation;
  late Animation<Offset> _animation2;
  late AnimationController _animationController;
  Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  Tween<Offset> _offset2 = Tween(begin: Offset(-1, 0), end: Offset(0, 0));
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseHelper _helper = FirebaseHelper();

  void sendMessage() {
    String messageText = messageController.text;
    Message message = Message(
      content: messageText,
      sender: _helper.getCurrentUser()!.uid,
      timeStamp: FieldValue.serverTimestamp(),
      type: 'text',
      conversationId: widget.conversationId,
    );
    _helper.sendMessageToDB(message);
    messageController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _animation = _offset.animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
    ));
    _animation2 = _offset2.animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuad,
    ));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.chatParticipant!.fullname,
              style: TextStyle(
                color: Color(0xFF005DAF),
                fontFamily: 'Quicksand-SemiBold',
                fontSize: 26,
              ),
            ),
            Icon(
              Icons.video_call_rounded,
              color: Color(0xFF005DAF),
              size: 40,
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .where('conversation_id', isEqualTo: widget.conversationId)
                  .orderBy('time_stamp',descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return ChatBubble(
                        message: snapshot.data!.docs[index].data()?['content'],
                        isMe: snapshot.data!.docs[index].data()?['sender'] ==
                                _helper.getCurrentUser()!.uid
                            ? true
                            : false,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SlideTransition(
                  position: _animation2,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    width: (MediaQuery.of(context).size.width) * 0.825,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 7,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Color(0xFFC5CEDD),
                              suffixIcon: GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.blueGrey,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SlideTransition(
                  position: _animation,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: (MediaQuery.of(context).size.width) * 0.125,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Icon(
                          FontAwesomeIcons.solidPaperPlane,
                          color: Color(0xFF5775A0),
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget senderLayout() {
    Radius messageRadius = Radius.circular(30);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.blue,
        ),
        child: Text(
          "Hello How Are youfghdfhsfghdsfghdsfghdfsghdfghdfghdghdfghdfghdfhdfghdfghdfhdfgh??",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
