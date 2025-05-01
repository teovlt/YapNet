import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/modeles/membre.dart';
import 'package:flutter_facebook_teo/services_firebase/service_storage.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> updateImage({
    required File file,
    required String folder,
    required String userId,
    required String imageName,
  }) async {
    try {
      final String downloadUrl = await ServiceStorage().addImage(
        file: file,
        folder: folder,
        userId: userId,
        imageName: imageName,
      );

      await updateMember(id: userId, data: {imageName: downloadUrl});
    } catch (e) {
      debugPrint('Error updating image: $e');
    }
  }

  allPosts() {
    return firestorePost.orderBy(dateKey, descending: true).snapshots();
  }

  allMembers() {
    return firestoreMember.snapshots();
  }

  postForMember(String memberId) {
    return firestorePost
        .where(memberIdKey, isEqualTo: memberId)
        .orderBy(dateKey, descending: true)
        .snapshots();
  }

  createPost({
    required Membre member,
    required String text,
    required XFile? image,
  }) async {
    final date = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> map = {
      memberIdKey: member.id,
      likesKey: [],
      dateKey: date,
      textKey: text,
    };

    if (image != null) {
      final url = await ServiceStorage().addImage(
        file: File(image.path),
        folder: postCollectionKey,
        userId: member.id,
        imageName: date.toString(),
      );
      map[postImageKey] = url;
    }

    await firestorePost.doc().set(map);
  }
}
