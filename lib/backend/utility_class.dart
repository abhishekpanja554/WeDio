import 'package:WEdio/models/calls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UtilityClass {
  String getInitials(String text) {
    List<String> names = text.split(" ");
    String initials = "";
    int numWords = 2;

    if (numWords < names.length) {
      numWords = names.length;
    }
    for (var i = 0; i < numWords; i++) {
      initials += '${names[i][0]}';
    }
    return initials;
  }

  static Future<bool> makeCall(String conversationId, Calls call) async {
    try {
      final CollectionReference callRef = FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId.trim())
          .collection('Call');

      var data = call.toMap(call);

      await callRef.doc('calling').set(data);

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> endCall(String conversationId) async {
    try {
      final CollectionReference callRef = FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId.trim())
          .collection('Call');

      // await callRef.doc().delete();
      await callRef.get().then((snapshot){
        for( DocumentSnapshot ds in snapshot.docs){
          ds.reference.delete();
        }
      });

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}
