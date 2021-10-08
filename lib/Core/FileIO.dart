import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:together/Model/Album.dart';
import 'package:flutter/services.dart' show rootBundle;

class FileIO {
  String ALBUMS = "albums.json";
  String DEFAULT_ALBUMS = "res/default_albums.json";
  String BACKGROUND = "background.txt";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile (String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

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
    return await readAsString(ALBUMS);
  }

  Future<String> _loadDefaultAlbumsAsset() async {
    return await rootBundle.loadString(DEFAULT_ALBUMS);
  }

  Future<List<Album>> loadAlbums() async {
    String jsonString = await _loadDefaultAlbumsAsset();
    var jsonResponse = json.decode(jsonString);
    var tmp = jsonResponse["albums"] as List;
    List<Album> defaultAlbums = tmp.map((album) => Album.fromJson(album)).toList();
    var all_albums = defaultAlbums;

    jsonString = await _loadAlbumsAsset();
    if (jsonString != "") {
      jsonResponse = json.decode(jsonString);
      tmp = jsonResponse["albums"] as List;
      List<Album> albums = tmp.map((album) => Album.fromJson(album)).toList();
      all_albums += albums;
    }

    return all_albums;
  }

  Future updateAlbums(List<Album> albums) async {
    List<Map<String, dynamic>> converted = albums.map((album) => album.toJson()).toList();
    Map<String, dynamic> data = {"albums": converted};
    final encodedString = json.encode(data);
    write(ALBUMS, encodedString);
  }

}