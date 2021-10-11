import 'package:flutter/material.dart';

import 'package:together/Controller/Login.dart';
import 'package:together/Core/Connectivity.dart';
import 'package:together/Server/Server.dart';
import 'package:together/View/AppTheme.dart';
import 'package:together/View/AppThemeData.dart';
import 'package:together/View/Themes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusSingleton.getInstance().initialize();
  await Server.instance.initializeBackend(Backend.FIREBASE);

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
