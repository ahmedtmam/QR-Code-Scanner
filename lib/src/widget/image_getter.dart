import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gx_file_picker/gx_file_picker.dart';
import '../common/commons.dart';

// ignore: must_be_immutable
class ImageGetter extends StatefulWidget {
  ImageData image;

  ImageGetter(this.image);

  @override
  _ImageGetterState createState() => _ImageGetterState();
}

class _ImageGetterState extends State<ImageGetter> {
  ImageData get image => widget.image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: grey,
        width: width(context, 0.5),
        height: height(context, 0.3),
        child: GestureDetector(
          onTap: getImage,
          child: Center(
            child: image.url == null
                ? Icon(
                    Icons.photo_camera,
                    size: 50,
                  )
                : image.fromServer
                    ? Image.network(image.url)
                    : Image.file(File(image.url)),
          ),
        ),
      ),
    );
  }

  void getImage() async {
    var imageFile = await FilePicker.getFile(type: FileType.image);
    if (imageFile == null) return;
    image.url = imageFile.path;
    image.fromServer = false;
    setState(() {});
  }
}

class ImageData {
  String url;
  bool fromServer;

  ImageData(this.url, this.fromServer);
}
