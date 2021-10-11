import 'package:flutter/material.dart';

import 'package:together/View/ChatTheme.dart';
import 'package:together/View/ColorPalette.dart';

class AppThemeData {
  final double padding;
  final ColorPalette colorPalette;
  final ChatTheme chatTheme;
  final ThemeData themeData;

  AppThemeData(
      {Key key,
      @required this.colorPalette,
      @required this.chatTheme,
      @required this.themeData,
      this.padding = 15.0});

  ThemeData get materialTheme {
    return themeData;
  }
}
