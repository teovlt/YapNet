import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';

class Notification {
  DocumentReference reference;
  String id;
  Map<String, dynamic> data;
  Notification({required this.reference, required this.id, required this.data});

  String get from => data[fromKey] ?? "";
  String get text => data[textKey] ?? "";
  int get date => data[dateKey] ?? 0;
  bool get isRead => data[isReadKey] ?? false;
  String get postId => data[postIdKey] ?? "";
}
