import 'package:WEdio/backend/firebase_helper.dart';
import 'package:WEdio/backend/utility_class.dart';
import 'package:WEdio/models/user.dart';
import 'package:flutter/material.dart';

class ContactTab extends StatefulWidget {
  @override
  _ContactTabState createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  FirebaseHelper _helper = FirebaseHelper();
  UtilityClass _utilityClass = UtilityClass();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F4385),
      body: Container(
        padding: EdgeInsets.only(top: 5),
        color: Color(0xFF1F4385),
        child: FutureBuilder(
          future: _helper.getDataFromDb(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: 2,
                  );
                },
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    height: 70,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Text(
                            _utilityClass.getInitials(
                                snapshot.data![index]['name'] ?? '-'),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Quicksand-Bold',
                              fontSize: 24,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data![index]['name'] ??
                                  snapshot.data![index]['phone'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Quicksand-SemiBold',
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              snapshot.data![index]['phone'],
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 16,
                                fontFamily: 'Quicksand-Regular',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
