import 'package:WEdio/enums/message_state.dart';
import 'package:flutter/material.dart';


class ImageMessageProvider with ChangeNotifier{
  MessageState messageState = MessageState.Done;

  MessageState get getMessageState => messageState;

  void setLoading(){
    messageState = MessageState.Loading;
    notifyListeners();
  }

  void setDone(){
    messageState = MessageState.Done;
    notifyListeners();
  }
}