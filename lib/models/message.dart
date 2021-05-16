class Message {
  late String content;
  late String sender;
  late DateTime timeStamp;
  late String conversationId;
  late String type;
  late bool isRead;
  late String imageUrl;

  Message({
    required this.content,
    required this.sender,
    required this.timeStamp,
    required this.type,
    required this.conversationId,
    required this.isRead,
  });

  Message.imageMessage({
    required this.content,
    required this.sender,
    required this.timeStamp,
    required this.type,
    required this.imageUrl,
    required this.conversationId,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'content': this.content,
      'sender': this.sender,
      'time_stamp': this.timeStamp,
      'type': this.type,
      'conversation_id': this.conversationId,
      'isRead': this.isRead,
    };
    return map;
  }

  Map<String, dynamic> toImageMsgMap(){
    Map<String, dynamic> map = {
      'content': this.content,
      'sender': this.sender,
      'time_stamp': this.timeStamp,
      'type': this.type,
      'conversation_id': this.conversationId,
      'isRead': this.isRead,
      'image_url':this.imageUrl,
    };
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.content = map['content'];
    this.sender = map['sender'];
    this.timeStamp = map['time_stamp'];
    this.type = map['type'];
    this.conversationId = map['conversation_id'];
    this.isRead = map['isRead'];
  }
}
