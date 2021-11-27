import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:together/Core/Logger.dart';
import 'package:together/Model/Album.dart';


class FileIO {
  static const String kAlbums = "albums.json";
  static const String kDefaultAlbums = "res/default_albums.json";
  static const String kBackground = "background.txt";

  static const String kChatBackgroundKey = "chat_background";

  // Utils
  Future<String> get _localPath async {
    Directory directory;
    if (!kIsWeb)
      directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> localFilePath(String filename) async {
    final path = await _localPath;
    return '$path/$filename';
  }

  Future<File> _localFile(String filename) async {
    final path = await localFilePath(filename);
    return File(path);
  }

  // Persistent File storage
  Future<File> persistFile(File tmpFile) async {
    final filename = basename(tmpFile.path);
    final persistentPath = await localFilePath(filename);

    return tmpFile.copy(persistentPath);
  }

  Future<File> persistXFile(XFile tmpFile) async {
    final filename = basename(tmpFile.path);
    final persistentPath = await localFilePath(filename);
    await tmpFile.saveTo(persistentPath);

    return File(persistentPath);
  }

  // Shared preferences
  Future<String> retrieveString(String key) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String value;
      try {
        value = prefs.getString(key);
      } catch (e) {
        logError(this.toString(), e.toString());
      }

      return value;
  }

  Future<bool> storeString(String key, String value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.setString(key, value);
  }

  static ImageProvider<Object> getImage(String path) {
    if (path.contains("res/")) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  // Download
  Future<String> downloadImage(String url) async {
    if (kIsWeb)
      return "";
    String imageId = await ImageDownloader.downloadImage(url);
    return await ImageDownloader.findPath(imageId);
  }

  // I/O
  Future<File> write(String filename, String contents) async {
    final file = await _localFile(filename);
    return file.writeAsString(contents);
  }

  Future<File> writeList(String filename, List<String> contents) async {
    final file = await _localFile(filename);

    String data = "";
    for (int i = 0; i < contents.length; i++) {
      data += contents[i] + "\n";
    }

    return file.writeAsString(data);
  }

  Future<File> append(String filename, String contents) async {
    final file = await _localFile(filename);
    String fileContent = await readAsString(filename);
    fileContent += contents;

    return file.writeAsString(fileContent);
  }

  Future<String> readAsString(String filename) async {
    try {
      final file = await _localFile(filename);

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<List<String>> readLines(String filename) async {
    try {
      final file = await _localFile(filename);

      // Read the file
      List<String> contents = await file.readAsLines();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  Future<String> _loadAlbumsAsset() async {
    return await readAsString(kAlbums);
  }

  Future<String> _loadDefaultAlbumsAsset() async {
    return await rootBundle.loadString(kDefaultAlbums);
  }

  Future<List<Album>> loadAlbums() async {
    String jsonString = await _loadDefaultAlbumsAsset();
    var jsonResponse = json.decode(jsonString);
    var tmp = jsonResponse["albums"] as List;
    List<Album> defaultAlbums = tmp.map((album) => Album.fromJson(album)).toList();
    var allAlbums = defaultAlbums;

    jsonString = await _loadAlbumsAsset();
    if (jsonString != "") {
      jsonResponse = json.decode(jsonString);
      tmp = jsonResponse["albums"] as List;
      List<Album> albums = tmp.map((album) => Album.fromJson(album)).toList();
      allAlbums += albums;
    }

    return allAlbums;
  }

  Future updateAlbums(List<Album> albums) async {
    List<Map<String, dynamic>> converted = albums.map((album) => album.toJson()).toList();
    Map<String, dynamic> data = {"albums": converted};
    final encodedString = json.encode(data);
    write(kAlbums, encodedString);
  }

}
