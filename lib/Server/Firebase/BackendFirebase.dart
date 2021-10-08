import 'package:firebase_core/firebase_core.dart';
import 'package:together/Server/Interface/AuthInterface.dart';
import 'package:together/Server/Interface/BackendInterface.dart';
import 'package:together/Server/Interface/DatabaseInterface.dart';
import 'package:together/Server/Interface/StorageInterface.dart';

import 'AuthFirebase.dart';
import 'CMFirebase.dart';
import 'DatabaseFirebase.dart';
import 'StorageFirebase.dart';

class BackendFirebase implements BackendInterface{
  // create a singleton
  static final BackendFirebase _singleton = new BackendFirebase._internal();
  BackendFirebase._internal();

  // initialization methods
  static BackendFirebase getInstance() => _singleton;
  factory BackendFirebase() => _singleton;
  static BackendFirebase get instance => _singleton;

  AuthInterface auth;
  DatabaseInterface database;
  StorageInterface storage;
  CMFirebase fcm;

  @override
  void initialize() async {
    await Firebase.initializeApp();

    auth = AuthFirebase();
    database = DatabaseFirebase();
    storage = StorageFirebase();

    fcm = CMFirebase();
  }

  @override
  void saveDeviceToken() async {
    String token = await fcm.getDeviceToken();
    String userId = await auth.getCurrentUserUid();

    database.saveDeviceToken(token, userId);
  }

}
