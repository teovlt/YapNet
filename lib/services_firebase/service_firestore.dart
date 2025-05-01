import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/modeles/membre.dart';
import 'package:flutter_facebook_teo/modeles/post.dart';
import 'package:flutter_facebook_teo/services_firebase/service_authentification.dart';
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

  Future<Map<String, dynamic>?> getMember(String memberId) async {
    final doc = await firestoreMember.doc(memberId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
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

  addLike({required String memberID, required Post post}) async {
    if (post.likes.contains(memberID)) {
      post.reference.update({
        likesKey: FieldValue.arrayRemove([memberID]),
      });
    } else {
      post.reference.update({
        likesKey: FieldValue.arrayUnion([memberID]),
      });

      if (post.member != memberID) {
        await sendNotification(
          from: memberID,
          to: post.member,
          text: "Votre post a reçu un like 👍",
          postId: post.id,
        );
      }
    }
  }

  addComment({required Post post, required String text}) async {
    final memberId = ServiceAuthentification().myId;
    final date = DateTime.now().millisecondsSinceEpoch;

    if (memberId == null) return;

    Map<String, dynamic> map = {
      memberIdKey: memberId,
      textKey: text,
      dateKey: date,
    };

    await post.reference.collection(commentCollectionKey).doc().set(map);

    if (post.member != memberId) {
      await sendNotification(
        from: memberId,
        to: post.member,
        text: "Vous avez reçu un commentaire sur votre post",
        postId: post.id,
      );
    }
  }

  postComment(String postId) {
    return firestorePost
        .doc(postId)
        .collection(commentCollectionKey)
        .orderBy(dateKey, descending: true)
        .snapshots();
  }

  getCommentsNumber(String postId) async {
    final snapshot =
        await firestorePost.doc(postId).collection(commentCollectionKey).get();
    return snapshot.docs.length;
  }

  sendNotification({
    required String to,
    required String from,
    required String text,
    required String postId,
  }) async {
    final date = DateTime.now().millisecondsSinceEpoch;
    final memberId = ServiceAuthentification().myId;

    if (memberId == null) return;

    Map<String, dynamic> map = {
      dateKey: date,
      isReadKey: false,
      fromKey: from,
      textKey: text,
      postIdKey: postId,
    };

    await firestoreMember
        .doc(to)
        .collection(notificationCollectionKey)
        .doc()
        .set(map);
  }

  markRead(DocumentReference reference) {
    reference.update({isReadKey: true});
  }

  notificationForUser(String id) {
    return firestoreMember
        .doc(id)
        .collection(notificationCollectionKey)
        .orderBy(dateKey, descending: true)
        .snapshots();
  }
}
