import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:together/Model/UserModel.dart';

import 'package:together/Server/Interface/AuthInterface.dart';
import 'package:together/Model/SimpleUserModel.dart';

enum AuthException {
  ERROR_USER_NOT_FOUND
}

class AuthFirebase implements AuthInterface {
  // Firebase instance
  final auth = FirebaseAuth.instance;

  // create a singleton
  static final AuthFirebase _singleton = new AuthFirebase._internal();
  AuthFirebase._internal();

  // initialization methods
  static AuthFirebase getInstance() => _singleton;
  factory AuthFirebase() => _singleton;
  static AuthFirebase get instance => _singleton;

  @override
  String USER_NOT_FOUND = 'ERROR_USER_NOT_FOUND';

  // methods
  @override
  Future<UserModel> createUser(
      String email, String password) async {
    final UserCredential firebaseUser = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    var user = new SimpleUser(email, firebaseUser.user.uid);

    return user;
  }

  @override
  Future<UserModel> signIn(
      String email, String password) async {
    final AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);

    final UserCredential firebaseUser = await auth.signInWithCredential(credential);

    var user = new SimpleUser(email, firebaseUser.user.uid);

    return user;
  }

  @override
  Future<String> getCurrentUserUid() async {
    final User currentUser = auth.currentUser;

    return currentUser.uid;
  }

  @override
  Future<String> getOtherUser(String currentUser, List<String> allUsers) async {
    allUsers.remove(currentUser);

    return allUsers[0];
  }

  @override
  Future<bool> userIsLoggedIn() async {
    final User currentUser = auth.currentUser;

    return currentUser != null;
  }

  @override
  Future signOut() async {
    await auth.signOut();
  }
}
