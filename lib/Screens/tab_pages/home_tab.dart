import 'package:WEdio/Screens/chat_page.dart';
import 'package:WEdio/backend/firebase_helper.dart';
import 'package:WEdio/global_variables.dart';
import 'package:WEdio/widgets/chatlist_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>
    with AutomaticKeepAliveClientMixin<HomeTab> {
  FirebaseHelper helper = FirebaseHelper();
  late Future<Null> _initData;

  Future<Null> getInitialData() async {
    await helper.getChatList(helper.getCurrentUser()).then((value) async {
      chatList = value;
      chatList.forEach((element) {
        print(element);
      });
      usersList = await helper.getAllUsers(value);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _initData = getInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color(0xFF1F4385),
      body: Container(
        padding: EdgeInsets.only(top: 5),
        color: Color(0xFF1F4385),
        child: FutureBuilder(
          future: _initData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.blue,
                      width: 7,
                    ),
                  ),
                  child: Lottie.asset(
                    'lotti_animations/loading4.json',
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chatParticipant: usersList[index]["user"],
                            conversationId: usersList[index]["conversationId"],
                          ),
                        ),
                      );
                    },
                    child: ChatListCard(
                      chatUser: usersList[index]["user"],
                      lastMessage: usersList[index]["last_message"],
                      isMe: usersList[index]["last_message_sender"] ==
                              helper.getCurrentUser()?.uid
                          ? true
                          : false,
                    ),
                  );
                },
                itemCount: usersList.length,
              );
            }
          },
        ),
      ),
    );
  }
}
