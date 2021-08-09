import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ImageLoadingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 3,
      ),
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(top: 7, bottom: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: messageRadius,
                bottomLeft: messageRadius,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 5,
                        right: 3,
                        top: 5,
                        left: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          // color: Colors.blueAccent,
                        ),
                        alignment: Alignment.centerRight,
                        height: 270,
                        child: Lottie.asset(
                          'lotti_animations/image-loading.json',
                        ),
                      ),
                    ),
                    Container(
                      height: 5,
                      width: 5,
                      margin: EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                // Container(
                //   margin:EdgeInsets.only(left: 10),
                //   child: Text(
                //     time,
                //     style: TextStyle(
                //       color: Colors.grey,
                //       fontSize: 12,
                //     ),
                //     textAlign: TextAlign.start,
                //   ),
                // ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 2,
          // ),
          // Container(
          //   margin: isMe ? EdgeInsets.only(right: 5) : EdgeInsets.only(left: 5),
          //   child: Text(
          //     date,
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 12,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
