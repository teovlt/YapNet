import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ServiceStorage {
  static final instance = FirebaseStorage.instance;
  Reference get ref => instance.ref();

  Future<String> addImage({
    required File file,
    required String folder,
    required String userId,
    required String imageName,
  }) async {
    final reference = FirebaseStorage.instance
        .ref()
        .child(folder)
        .child(userId)
        .child(imageName);

    UploadTask task = reference.putFile(file);
    TaskSnapshot snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }
}
