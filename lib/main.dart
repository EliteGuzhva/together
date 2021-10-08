import 'package:flutter/material.dart';

import 'package:together/Controller/Login.dart';
import 'package:together/Core/Connectivity.dart';
import 'package:together/Server/Server.dart';
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
    return MaterialApp(
      title: 'Together',
      theme: kDefaultTheme,
      home: Login(),
    );
  }
}
