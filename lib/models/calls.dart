class Calls {
  String callerId;
  String recieverId;
  String callId;
  String conversationId;

  Calls({
    required this.callId,
    required this.callerId,
    required this.recieverId,
    required this.conversationId,
  });

  factory Calls.fromMap(Map<String, dynamic> call) => Calls(
        callId: call['callId'],
        callerId: call['callId'],
        recieverId: call['recieverId'],
        conversationId: call['conversationId'],
      );

  Map<String, dynamic> toMap(Calls call) {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['callId'] = call.callId;
    data['callerId'] = call.callerId;
    data['recieverId'] = call.recieverId;
    data['conversationId'] = call.conversationId;
    return data;
  }
}
