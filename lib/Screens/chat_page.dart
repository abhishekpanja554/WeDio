import 'dart:io';
import 'dart:math';

import 'package:WEdio/backend/firebase_helper.dart';
import 'package:WEdio/enums/message_state.dart';
import 'package:WEdio/models/message.dart';
import 'package:WEdio/models/user.dart';
import 'package:WEdio/providers/image_message_provider.dart';
import 'package:WEdio/widgets/chat_bubble.dart';
import 'package:WEdio/widgets/image_loading_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
  ScrollController scrollController = new ScrollController();
  late ImageMessageProvider _imageMessageProvider;

  void sendMessage() {
    String messageText = messageController.text;
    Message message = Message(
      content: messageText,
      sender: _helper.getCurrentUser()!.uid,
      timeStamp: DateTime.now(),
      type: 'text',
      conversationId: widget.conversationId,
      isRead: false,
    );
    _helper.sendMessageToDB(message, widget.conversationId);
    messageController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void sendReadAchk(bool isRead, String id) async {
    await _firestore.collection('messages').doc(id).update({'isRead': true});
  }

  void pickImage({required ImageSource source}) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile = (await picker.getImage(source: source))!;

    File chosenImage = File(pickedFile.path);
    await _helper.uploadImage(
        chosenImage, widget.conversationId, _imageMessageProvider);
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
    _imageMessageProvider = Provider.of<ImageMessageProvider>(context);
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
                  .orderBy('time_stamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  SchedulerBinding.instance!.addPostFrameCallback((_) {
                    scrollController.jumpTo(
                      scrollController.position.maxScrollExtent,
                    );
                  });

                  return ListView.builder(
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      String time = DateFormat.jm().format(
                          (snapshot.data!.docs[index].data()['time_stamp'])
                              .toDate());

                      String date = DateFormat.yMMMMd().format(
                          (snapshot.data!.docs[index].data()['time_stamp'])
                              .toDate());
                      bool isRead =
                          snapshot.data!.docs[index].data()['isRead'] == null
                              ? null
                              : snapshot.data!.docs[index].data()['isRead'];
                      if (!isRead &&
                          !(snapshot.data!.docs[index].data()['sender'] ==
                              _helper.getCurrentUser()!.uid)) {
                        sendReadAchk(isRead, snapshot.data!.docs[index].id);
                      }

                      return ChatBubble(
                        message: snapshot.data!.docs[index].data()['content'],
                        isMe: snapshot.data!.docs[index].data()['sender'] ==
                                _helper.getCurrentUser()!.uid
                            ? true
                            : false,
                        time: time,
                        date: date,
                        isRead: isRead,
                        type: snapshot.data!.docs[index].data()['type'],
                        url: snapshot.data!.docs[index].data()['image_url']??'',
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
          _imageMessageProvider.getMessageState == MessageState.Loading
              ? ImageLoadingBubble()
              : Container(),
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
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 260,
                                  margin: EdgeInsets.all(20),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    color: Color(0xFF1F4385),
                                  ),
                                  child: GridView.count(
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 3,
                                    children: [
                                      ModalGridTile(
                                        title: 'Camera',
                                        circleBackground: Colors.purpleAccent,
                                        icon: Icons.camera_alt,
                                        iconSize: 30,
                                      ),
                                      ModalGridTile(
                                        title: 'Document',
                                        circleBackground: Colors.blueAccent,
                                        icon: FontAwesomeIcons.fileAlt,
                                        iconSize: 25,
                                      ),
                                      ModalGridTile(
                                        title: 'Galary',
                                        circleBackground: Colors.pinkAccent,
                                        icon: Icons.image,
                                        iconSize: 30,
                                      ),
                                      ModalGridTile(
                                        title: 'Location',
                                        circleBackground: Colors.greenAccent,
                                        icon: Icons.location_on,
                                        iconSize: 30,
                                      ),
                                      ModalGridTile(
                                        title: 'Contact',
                                        circleBackground:
                                            Colors.lightBlueAccent,
                                        icon: Icons.contact_phone,
                                        iconSize: 30,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: Transform.rotate(
                              angle: pi / 4,
                              child: Icon(
                                Icons.attach_file_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
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
                                onTap: () =>
                                    pickImage(source: ImageSource.camera),
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
                  child: GestureDetector(
                    onTap: sendMessage,
                    child: Container(
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModalGridTile extends StatelessWidget {
  final String title;
  final Color circleBackground;
  final IconData icon;
  final double iconSize;

  ModalGridTile({
    required this.title,
    required this.icon,
    required this.circleBackground,
    required this.iconSize,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF5775A0),
      elevation: 4,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: circleBackground,
            child: Icon(
              icon,
              size: iconSize,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
