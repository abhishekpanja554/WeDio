import 'package:WEdio/backend/utility_class.dart';
import 'package:WEdio/models/calls.dart';
import 'package:flutter/material.dart';

class CallerScreen extends StatefulWidget {
  final String conversationId;
  final Calls call;
  CallerScreen({
    required this.conversationId,
    required this.call,
  });
  @override
  _CallerScreenState createState() => _CallerScreenState();
}

class _CallerScreenState extends State<CallerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 100,
          child: Column(
            children: [
              Text('Calling'),
              ElevatedButton(
                onPressed: () async {
                  await UtilityClass.endCall(widget.conversationId);
                  Navigator.pop(context);
                },
                child: Text('End Call'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
