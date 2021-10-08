import 'package:together/Server/Firebase/BackendFirebase.dart';
import 'package:together/Server/Interface/AuthInterface.dart';
import 'package:together/Server/Interface/BackendInterface.dart';
import 'package:together/Server/Interface/DatabaseInterface.dart';
import 'package:together/Server/Interface/StorageInterface.dart';

enum Backend {
  FIREBASE
}

class Server {
  // create a singleton
  static final Server _singleton = new Server._internal();
  Server._internal();

  // initialization methods
  static Server getInstance() => _singleton;
  factory Server() => _singleton;
  static Server get instance => _singleton;

  // params
  BackendInterface _backend;

  // methods
  Future initializeBackend(Backend backend) async {
    switch (backend) {
      case Backend.FIREBASE:
        _backend = BackendFirebase();
        await _backend.initialize();
        break;
      default:
        print("Invalid backend!");
    }
  }

  AuthInterface get auth => _backend.auth;
  DatabaseInterface get database => _backend.database;
  StorageInterface get storage => _backend.storage;
  BackendInterface get backend => _backend;
}