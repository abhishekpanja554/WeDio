import 'package:flutter/material.dart';

class RecieverScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('Accept'),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Deny'),
            ),
          ],
        ),
      ),
    );
  }
}