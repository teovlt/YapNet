import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/services_firebase/service_storage.dart';

class ServiceFirestore {
  static final instance = FirebaseFirestore.instance;
  final firestoreMember = instance.collection(memberCollectionKey);

  addMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).set(data);
  }

  updateMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).update(data);
  }

  updateImage({
    required File file,
    required String folder,
    required String memberId,
    required String imageName,
  }) {
    ServiceStorage()
        .addImage(
          file: file,
          folder: folder,
          memberId: memberId,
          imageName: imageName,
        )
        .then(
          (imageUrl) => {
            updateMember(id: memberId, data: {imageName: imageUrl}),
          },
        );
  }
}
