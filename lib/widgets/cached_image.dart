import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CachedImage extends StatelessWidget {
  final String url;

  CachedImage({required this.url});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        height: 350,
        imageUrl: url,
        placeholder: (context, url) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              // color: Colors.blueAccent,
            ),
            alignment: Alignment.center,
            height: 100,
            child: Lottie.asset(
              'lotti_animations/image-loading.json',
            ),
          );
        },
      ),
    );
  }
}
