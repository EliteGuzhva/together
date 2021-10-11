import 'package:flutter/material.dart';

import 'package:together/Core/Logger.dart';
import 'package:together/Server/Server.dart';
import 'package:together/Core/UIFunctions.dart';
import 'package:together/Controller/Login.dart';
import 'package:together/Core/FileIO.dart';
import 'package:together/View/Themes.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Server _server = Server.getInstance();

  final fio = FileIO();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: Text("Сменить тему"),
                onPressed: () {
                  ThemeManager.instance.theme = ThemeManager.instance.nextTheme();
                }
              ),
              ElevatedButton(
                child: Text("Выйти"),
                onPressed: () {
                  _server.auth.signOut().whenComplete(() {
                    pushReplacePage(context, Login());
                  });
                },
                onLongPress: () async {
                    fio.write(mainLog + ".txt", "");
                    showSnack(context, "Cleared logs");
                }
              )
            ],
          ),
        ));
  }
}
