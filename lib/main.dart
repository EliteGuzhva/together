import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:together/Controller/Login.dart';
import 'package:together/Core/Connectivity.dart';
import 'package:together/Core/FileIO.dart';
import 'package:together/Server/Server.dart';
import 'package:together/View/AppTheme.dart';
import 'package:together/View/AppThemeData.dart';
import 'package:together/View/Themes.dart';


Future initChatBackground() async {
  final fio = FileIO();
  String bg = await fio.retrieveString(FileIO.kChatBackgroundKey);
  bool bgExists = bg != null;
  if (!kIsWeb)
    bgExists = bgExists && await File(bg).exists();

  if (bg == null || bg == "" || (!bg.contains("res/") && !bgExists)) {
    bg = "res/bg1.jpg";
    await fio.storeString(FileIO.kChatBackgroundKey, bg);
  }

  ThemeManager.instance.chatBackground = bg;
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusSingleton.getInstance().initialize();
  await Server.instance.initializeBackend(Backend.FIREBASE);
  await initChatBackground();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: ThemeManager.instance.fromString("Default"),
        stream: ThemeManager.instance.themeStream,
        builder: (context, snapshot) {
          AppThemeData appTheme = snapshot.data;
          return AppTheme(
            child: MaterialApp(
              title: 'Together',
              theme: appTheme.themeData,
              home: Login(),
            ),
            appThemeData: appTheme,
          );
        });
  }
}
