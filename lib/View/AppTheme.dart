import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:together/View/AppThemeData.dart';


class AppTheme extends StatelessWidget {
  final Widget child;
  final AppThemeData appThemeData;

  AppTheme({
    @required this.child,
    @required this.appThemeData});

  @override
  Widget build(BuildContext context) {
    return ProxyProvider0(update: (_, __) => appThemeData, child: child);
  }
}
