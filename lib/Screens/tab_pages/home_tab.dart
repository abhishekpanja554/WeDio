import 'package:WEdio/Screens/chat_page.dart';
import 'package:WEdio/backend/firebase_helper.dart';
import 'package:WEdio/global_variables.dart';
import 'package:WEdio/widgets/chatlist_card.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  FirebaseHelper helper = FirebaseHelper();

  bool reloadFlag = false;

  Future<Null> getInitialData() async {
    await helper.getChatList(helper.getCurrentUser()).then((value) async {
      chatList = value;
      usersList = await helper.getAllUsers(value);
    });
  }

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F4385),
      body: Container(
        color: Color(0xFF1F4385),
        child: FutureBuilder(
          future: getInitialData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  height: 500,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Loading Chats...!!!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Quicksand-Regular',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chatParticipant: usersList[index],
                          ),
                        ),
                      );
                    },
                    child: ChatListCard(
                      chatUser: usersList[index],
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
