import 'package:flutter/services.dart';

abstract class StorageInterface {
  Future<List<String>> uploadPhoto(String dir, String id, ByteData data);
  Future deletePhoto(String dir, String filename);
}