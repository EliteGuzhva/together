import 'package:flutter/material.dart';


// Default
const kDefaultThemeUnselectedButtonColor = Colors.blueGrey;

const kDefaultColorScheme = ColorScheme.light(
    primary: Color(0xFF00538a),
    primaryVariant: Color(0xFF216695),
    secondary: Color(0xFF00538a),
    secondaryVariant: Color(0xFF216695),
    background: Color(0xFFF2F3F4),
    surface: Colors.white
);

final kDefaultTheme = ThemeData(
    iconTheme: IconThemeData(color: kDefaultColorScheme.primaryVariant),
    colorScheme: kDefaultColorScheme,
    appBarTheme: AppBarTheme(
        color: kDefaultColorScheme.background,
        titleTextStyle: TextStyle(
            color: kDefaultColorScheme.primary,
            fontFamily: "Qwigley",
            fontSize: 40.0),
        iconTheme: IconThemeData(color: kDefaultColorScheme.primaryVariant)),
    buttonTheme: ButtonThemeData(
        buttonColor: kDefaultColorScheme.primary,
        textTheme: ButtonTextTheme.primary,
        minWidth: 150.0,
        height: 40,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0))),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            primary: kDefaultColorScheme.primary,
            minimumSize: Size(150.0, 40.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0)),
        )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kDefaultColorScheme.background,
        selectedItemColor: kDefaultColorScheme.primaryVariant,
        unselectedItemColor: kDefaultThemeUnselectedButtonColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.shifting
    ),
    scaffoldBackgroundColor: kDefaultColorScheme.background,
);
