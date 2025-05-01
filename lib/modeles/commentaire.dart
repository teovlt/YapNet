import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';

class Commentaire {
  DocumentReference reference;
  String id;
  Map<String, dynamic> map;

  Commentaire({required this.reference, required this.id, required this.map});

  String get member => map[memberIdKey] ?? "";
  String get text => map[textKey] ?? "";
  int get date => map[dateKey] ?? 0;
}
