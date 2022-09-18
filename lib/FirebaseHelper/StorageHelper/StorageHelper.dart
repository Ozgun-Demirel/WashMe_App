
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';


class StorageHelper {

  static Future<String> uploadFile(File file, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }

  static deleteFolder(List<String> paths) async {

    for (var path in paths) {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.delete();
    }

  }

  /*
  static getFile(String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);


  }

   */



}