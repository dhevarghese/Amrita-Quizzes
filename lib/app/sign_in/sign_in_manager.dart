import 'dart:async';

import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthService auth;
  final ValueNotifier<bool> isLoading;

  Future<MyAppUser> _signIn(Future<MyAppUser> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }


  Future<void> signInWithGoogle() async {
    return await _signIn(auth.signInWithGoogle);
  }
}
