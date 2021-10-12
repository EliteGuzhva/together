import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

import 'package:together/Core/FileIO.dart';
import 'package:together/View/AppThemeData.dart';
import 'package:together/View/Themes/DefaultTheme.dart';
import 'package:together/View/Themes/GruvboxMaterialDarkTheme.dart';


class ThemeManager {
  static final ThemeManager _singleton = ThemeManager._internal();
  ThemeManager._internal();

  static ThemeManager get instance => _singleton;

  var _chatBackgroundStreamController = BehaviorSubject<ImageProvider<Object>>();
  Stream<ImageProvider<Object>> get chatBackgroundStream => _chatBackgroundStreamController.stream;

  set chatBackground(String path) {
    final img = FileIO.getImage(path);
    _chatBackgroundStreamController.sink.add(img);
  }

  void setChatBackground(String path, Function callback) async {
    final FileIO fio = FileIO();

    chatBackground = path;
    await fio
        .storeString(FileIO.kChatBackgroundKey, path)
        .whenComplete(() => callback());
  }

  var _themeStreamController = BehaviorSubject<AppThemeData>();
  Stream<AppThemeData> get themeStream => _themeStreamController.stream;

  set theme(String name) {
    _themeStreamController.sink.add(fromString(name));
    themeIdx = themes.indexOf(name);
    if (themeIdx == -1)
      themeIdx = 0;
  }

  List<String> _themes = [
    "Default",
    "GruvboxMaterialDark"
  ];
  List<String> get themes => _themes;

  int themeIdx = 0;

  String nextTheme() {
    if (themeIdx < themes.length - 1) {
      return themes[themeIdx + 1];
    } else {
      return themes[0];
    }
  }

  AppThemeData fromString(String name) {
    if (name == "Default")
      return kDefaultAppTheme;
    else if (name == "GruvboxMaterialDark")
      return kGruvboxMaterialDarkAppTheme;
    else
      return kDefaultAppTheme;
  }

  void dispose() {
    _themeStreamController.close();
    _chatBackgroundStreamController.close();
  }
}
