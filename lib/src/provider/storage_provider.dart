import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widget/widgets.dart';

class StorageProvider {
  var _storage = FirebaseStorage.instance;

  Future<String> uploadImage(ImageData image) async {
    String downloadLink;
    try {
      var task = await _storage
          .ref()
          .child('studentImages')
          .child('${Timestamp.now()}.png')
          .putFile(
            File(image.url),
          );

      if (task.state == TaskState.success) {
        downloadLink = await task.ref.getDownloadURL();
        return downloadLink;
      } else {
        return downloadLink;
      }
    } catch (e) {
      return downloadLink;
    }
  }
}
