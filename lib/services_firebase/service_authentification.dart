import 'package:firebase_auth/firebase_auth.dart';

class ServiceAuthentification {
  final FirebaseAuth instance = FirebaseAuth.instance;

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    String result = '';
    return result;
  }

  Future<String> signUp({
    required String email,
    required String password,
    required String surname,
    required String name,
  }) async {
    String result = '';
    return result;
  }

  Future<bool> signOut() async {
    bool result = false;
    return result;
  }

  String? get myId => instance.currentUser?.uid;

  bool isMe(String id) {
    bool result = false;
    return result;
  }
}
