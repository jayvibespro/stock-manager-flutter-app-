import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File image) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(image);
    } on FirebaseException catch (e) {
      print(e.toString());
      return null;
    }
  }
}
