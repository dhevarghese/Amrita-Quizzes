import 'dart:async';

import 'package:meta/meta.dart';

@immutable
class MyAppUser {
  const MyAppUser({
    @required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
}

abstract class AuthService {
  Future<MyAppUser> currentUser();
  Future<MyAppUser> signInWithEmailAndPassword(String email, String password);
  Future<MyAppUser> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<MyAppUser> signInWithEmailAndLink({String email, String link});

  Future<MyAppUser> signInWithGoogle();
  Future<void> signOut();
  Stream<MyAppUser> get onAuthStateChanged;
  void dispose();
}
