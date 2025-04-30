import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/services_firebase/service_storage.dart';

class ServiceFirestore {
  static final instance = FirebaseFirestore.instance;
  final firestoreMember = instance.collection(memberCollectionKey);
  final firestorePost = instance.collection(postCollectionKey);

  addMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).set(data);
  }

  updateMember({required String id, required Map<String, dynamic> data}) {
    firestoreMember.doc(id).update(data);
  }

  specificMember(String memberId) {
    return firestoreMember.doc(memberId).snapshots();
  }

  updateImage({
    required File file,
    required String folder,
    required String userId,
    required String imageName,
  }) {
    ServiceStorage()
        .addImage(
          file: file,
          folder: folder,
          userId: userId,
          imageName: imageName,
        )
        .then(
          (imageUrl) => {
            updateMember(id: userId, data: {imageName: imageUrl}),
          },
        );
  }

  allPosts() {
    return firestorePost.orderBy(dateKey, descending: true).snapshots();
  }

  postForMember(String memberId) {
    return firestorePost.where(memberIdKey, isEqualTo: memberId).snapshots();
  }
}
