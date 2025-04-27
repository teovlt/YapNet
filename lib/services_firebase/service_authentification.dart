import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';

class ServiceAuthentification {
  final FirebaseAuth instance = FirebaseAuth.instance;

  Future signIn({required String email, required String password}) async {
    try {
      await instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future signUp({
    required String email,
    required String password,
    required String surname,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await ServiceFirestore().addMember(
        id: userCredential.user!.uid,
        data: {'email': email, 'surname': surname, 'name': name},
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future signOut() async {
    try {
      await instance.signOut();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  String? get myId => instance.currentUser?.uid;

  bool isMe(String id) {
    bool result = false;
    return result;
  }
}
