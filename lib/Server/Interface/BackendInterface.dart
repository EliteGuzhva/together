import 'AuthInterface.dart';
import 'DatabaseInterface.dart';
import 'StorageInterface.dart';

abstract class BackendInterface {
  AuthInterface auth;
  DatabaseInterface database;
  StorageInterface storage;

  void initialize();
  void saveDeviceToken();
}