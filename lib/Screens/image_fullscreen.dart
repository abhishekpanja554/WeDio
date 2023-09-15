import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class ImageFullscreen extends StatelessWidget {
  final String url;
  ImageFullscreen({required this.url});

  _save() async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + DateTime.now().toString();
    await Dio().download(url, savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 15,
        toolbarHeight: 70,
        backgroundColor: Color(0xFF1F4385),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 30,
          ),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Image',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand-SemiBold',
                fontSize: 26,
              ),
            ),
            IconButton(
              onPressed: () {
                _save();
              },
              icon: Icon(
                Icons.download_rounded,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(url),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        loadingBuilder: (context, imageChunkEvent) {
          return Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
