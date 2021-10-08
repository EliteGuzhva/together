import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:together/Core/Logger.dart';
import 'package:together/Server/Interface/StorageInterface.dart';

class StorageFirebase implements StorageInterface {
  // Firebase instance
  final storage = FirebaseStorage.instance;

  // create a singleton
  static final StorageFirebase _singleton = new StorageFirebase._internal();
  StorageFirebase._internal();

  // initialization methods
  static StorageFirebase getInstance() => _singleton;
  factory StorageFirebase() => _singleton;
  static StorageFirebase get instance => _singleton;

  @override
  Future<List<String>> uploadPhoto(
      String dir, String id, ByteData data) async {

    logDebug(this.toString(), "Uploading...");

    final Reference storageReference =
        storage.ref().child(dir + "/" + id + ".jpg");

    List<int> imageData = data.buffer.asUint8List();

    final UploadTask uploadTask = storageReference.putData(
        imageData, SettableMetadata(contentType: "image/jpeg"));

    final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => null));

    String url = (await downloadUrl.ref.getDownloadURL());

    List<String> result = [id, url];

    return result;
  }

  @override
  Future deletePhoto(String dir, String filename) async {
    try
    {
      storage.ref().child(dir + "/" + filename).delete();
    }
    catch (e)
    {
      logError(this.toString(), e.toString());
    }
  }
}
