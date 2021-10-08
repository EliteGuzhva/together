import 'package:flutter/material.dart';

import 'package:together/Controller/Login.dart';
import 'package:together/Core/Connectivity.dart';
import 'package:together/Server/Server.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusSingleton.getInstance().initialize();
  await Server.instance.initializeBackend(Backend.FIREBASE);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color _mainColor = Color(0xFF00538a);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Together',
      theme: ThemeData(
        primaryColor: _mainColor,
        appBarTheme: AppBarTheme(
            color: Color(0xFFF2F3F4),
            textTheme: TextTheme(
                headline6: TextStyle(
                    fontFamily: "Qwigley", fontSize: 40.0, color: _mainColor)),
            iconTheme: IconThemeData(color: _mainColor)),
        buttonTheme: ButtonThemeData(
            buttonColor: _mainColor,
            textTheme: ButtonTextTheme.primary,
            minWidth: 150.0,
            height: 40,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(0.0))),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: _mainColor,
                minimumSize: Size(150.0, 40.0),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(0.0)),
            )
        ),
        scaffoldBackgroundColor: Color(0xFFf3f3f3),
      ),
      home: Login(),
    );
  }
}
