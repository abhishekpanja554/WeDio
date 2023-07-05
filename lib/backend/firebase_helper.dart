import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:WEdio/global_variables.dart';
import 'package:WEdio/models/message.dart';
import 'package:WEdio/models/user.dart';
import 'package:WEdio/providers/image_message_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:google_sign_in/google_sign_in.dart';

class FirebaseHelper {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storageRef =
      firebase_storage.FirebaseStorage.instance;
  List<User> contactList = [];

  auth.User? getCurrentUser() {
    auth.User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }
  // Future<UserCredential> signIn() async {
  //   GoogleSignInAccount _signInAcc = await (_googleSignIn.signIn() as FutureOr<GoogleSignInAccount>);
  //   GoogleSignInAuthentication _signInAuth = await _signInAcc.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: _signInAuth.accessToken,
  //     idToken: _signInAuth.idToken,
  //   );
  //   UserCredential user = await _auth.signInWithCredential(credential);
  //   return user;
  // }

  // Future<bool> authenticateUser(UserCredential user) async {
  //   QuerySnapshot result = await _firestore
  //       .collection("users")
  //       .where("email", isEqualTo: user.user!.email)
  //       .get();

  //   final List<DocumentSnapshot> docs = result.docs;

  //   return docs.length == 0 ? true : false;
  // }

  Future<Null> updateContacts(context) async {
    // final PermissionStatus permissionStatus = await _getPermission();
    if (await Permission.contacts.request().isGranted) {
      contacts = await ContactsService.getContacts(withThumbnails: false);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Permissions error'),
          content: Text('Please enable contacts access '
              'permission in system settings'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }
  }

  // Future<PermissionStatus> _getPermission() async {
  //   final PermissionStatus permission = await Permission.contacts.status;
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.denied) {
  //     final Map<Permission, PermissionStatus> permissionStatus =
  //         await [Permission.contacts].request();
  //     return permissionStatus[Permission.contacts] ??
  //         PermissionStatus.restricted;
  //   } else {
  //     return permission;
  //   }
  // }

  Future<List<User>> getAllAvailableCOntacts() async {
    for (var i in contacts) {
      // i.phones!.forEach((element) async {
      if (i.phones!.length > 0) {
        await _firestore
            .collection('users')
            .where('phone', isEqualTo: i.phones!.first.value)
            .get()
            .then((value) {
          if (value.docs.length > 0) {
            if (!contactList.contains(User.fromDocument(value.docs[0])) ||
                User.fromDocument(value.docs[0]).uid != getCurrentUser()!.uid) {
              contactList.add(User.fromDocument(value.docs[0]));
            }
          }
        });
      }

      // });
    }
    return contactList;
  }

  Future<Database> createContactDb() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'contacts.db';

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Contact (uid TEXT PRIMARY KEY,name TEXT,phone TEXT)');
    });

    return database;
  }

  Future<Null> insertContactIntoDb(
      Database database, String uid, String name, String phone) async {
    // var databasesPath = await getDatabasesPath();
    // String path = databasesPath + 'contacts.db';
    // Database database = await openDatabase(
    //   path,
    //   version: 1,
    // );

    await database.insert("Contact", {
      "uid": uid,
      "name": name,
      "phone": phone,
    });

    // await database.transaction((txn) async {
    //   await txn.rawInsert(
    //       'INSERT INTO Contact(uid, name, phone) VALUES($uid,$name,$phone)');
    // });
  }

  Future<List<Map>> getDataFromDb() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'contacts.db';
    Database database = await openDatabase(
      path,
      version: 1,
    );
    List<Map<String, dynamic>> list =
        await database.rawQuery('SELECT * FROM Contact');
    // return List.generate(list.length, (index) {

    // });
    return list;
  }

  Future<Null> deleteTable() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'contacts.db';
    await deleteDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getAllUsers(List chatList) async {
    List<Map<String, dynamic>> users = [];
    for (var item in chatList) {
      var i =
          await _firestore.collection('users').doc(item['participantId']).get();
      users.add({
        "user": User.fromDocument(i),
        "conversationId": item['conversationId'],
        "last_message": item['last_message'],
        "last_message_sender": item['last_message_sender'],
      });
    }
    return users;
  }

  Future<Null> sendImageMsg(String imageUrl, String conversationId) async {
    Message _message = Message.imageMessage(
      content: 'Image',
      sender: getCurrentUser()!.uid,
      timeStamp: DateTime.now(),
      type: 'image',
      imageUrl: imageUrl,
      isRead: false,
      conversationId: conversationId,
    );

    Map<String, dynamic> map = _message.toImageMsgMap();
    await _firestore.collection('messages').add(map);
    await _firestore
        .collection('conversations')
        .doc(conversationId.trim())
        .update({
      'last_message': _message.content,
      'last_message_sender': getCurrentUser()!.uid,
    });
  }

  Future<Null> uploadImage(File image, String conversationId,
      ImageMessageProvider imageMessageProvider) async {
    String fileUrl;
    imageMessageProvider.setLoading();
    firebase_storage.TaskSnapshot uploadTask = await storageRef
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}')
        .putFile(image);
    fileUrl = await uploadTask.ref.getDownloadURL();
    imageMessageProvider.setDone();
    await sendImageMsg(fileUrl, conversationId);
  }

  Future<void> sendMessageToDB(Message message, String conversationId) async {
    Map<String, dynamic> map = message.toMap();
    await _firestore.collection('messages').add(map);
    await _firestore
        .collection('conversations')
        .doc(conversationId.trim())
        .update({
      'last_message': message.content,
      'last_message_sender': getCurrentUser()!.uid,
    });
  }

  Future<List> getChatList(auth.User? currentUser) async {
    List chatList = [];
    QuerySnapshot<Map> res1 = await _firestore
        .collection('conversations')
        .where(
          'person1',
          isEqualTo: currentUser!.uid,
        )
        .get();
    QuerySnapshot<Map> res2 = await _firestore
        .collection('conversations')
        .where(
          'person2',
          isEqualTo: currentUser.uid,
        )
        .get();
    res1.docs.forEach((element) {
      chatList.add({
        "participantId": element.data()['person2'],
        "conversationId": element.data()['conversation_id'],
        "last_message": element.data()['last_message'],
        "last_message_sender": element.data()['last_message_sender'],
      });
    });
    res2.docs.forEach((element) {
      chatList.add({
        "participantId": element.data()['person1'],
        "conversationId": element.data()['conversation_id'],
        "last_message": element.data()['last_message'],
        "last_message_sender": element.data()['last_message_sender'],
      });
    });

    return chatList;
  }

  // Future<String> getConversationId(
  //     User participantUID, auth.User? currentUser) async {
  //   QuerySnapshot res;
  //   res = await _firestore
  //       .collection('conversations')
  //       .where(
  //         'person1',
  //         isEqualTo: participantUID.uid,
  //       )
  //       .where(
  //         'person2',
  //         isEqualTo: currentUser!.uid,
  //       )
  //       .get();
  //   if (res.size == 0) {
  //     res = await _firestore
  //         .collection('conversations')
  //         .where(
  //           'person1',
  //           isEqualTo: currentUser.uid,
  //         )
  //         .where(
  //           'person2',
  //           isEqualTo: participantUID.uid,
  //         )
  //         .get();
  //   }

  //   return res.docs.first.id;
  // }
}
