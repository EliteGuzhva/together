import 'package:flutter/material.dart';
import 'package:together/View/AppThemeData.dart';

import 'package:together/View/ChatTheme.dart';
import 'package:together/View/ColorPalette.dart';

// Colors
const kDefaultThemeUnselectedButtonColor = Colors.blueGrey;

const kDefaultColorPalette = ColorPalette(
    background: const Color(0xFFF2F3F4),
    foreground: Colors.white,
    black: Colors.black38,
    blackBright: Colors.black,
    red: Color(0xFFFF7777),
    redBright: Colors.red,
    green: Color(0xFFCCFFEE),
    greenBright: Colors.green,
    yellow: Color(0xFFFFFF88),
    yellowBright: Colors.yellow,
    blue: Color(0xFF216695),
    blueBright: Color(0xFF00538a),
    magenta: Colors.purple,
    cyan: Color(0xFFCCEEFF),
    white: Colors.white70,
    whiteBright: Colors.white,
);

final kDefaultColorScheme = ColorScheme.light(
    primary: kDefaultColorPalette.blueBright,
    primaryVariant: kDefaultColorPalette.blue,
    secondary: kDefaultColorPalette.blueBright,
    secondaryVariant: kDefaultColorPalette.blue,
    background: kDefaultColorPalette.background,
    surface: kDefaultColorPalette.foreground,
    error: kDefaultColorPalette.red,
    onPrimary: kDefaultColorPalette.foreground,
    onSecondary: kDefaultColorPalette.foreground,
    onError: kDefaultColorPalette.foreground,
    onBackground: kDefaultColorPalette.blackBright,
    onSurface: kDefaultColorPalette.blackBright
);

// Icons
final kDefaultIconTheme =
    IconThemeData(color: kDefaultColorScheme.primaryVariant);

// AppBar
final kDefaultAppBarTitleTextStyle = TextStyle(
    color: kDefaultColorScheme.primary,
    fontFamily: "Qwigley",
    fontSize: 40.0
);

final kDefaultAppBarTheme = AppBarTheme(
    color: kDefaultColorScheme.background,
    titleTextStyle: kDefaultAppBarTitleTextStyle,
    iconTheme: kDefaultIconTheme
);

// Buttons
const kDefaultButtonMinWidth = 150.0;
const kDefaultButtonHeight = 40.0;
const kDefaultButtonRadius = 0.0;
final kDefaultButtonBackground = kDefaultColorScheme.primary;
final kDefaultButtonForeground = kDefaultColorScheme.onPrimary;

final kDefaultButtomTheme = ButtonThemeData(
    buttonColor: kDefaultButtonBackground,
    textTheme: ButtonTextTheme.primary,
    minWidth: kDefaultButtonMinWidth,
    height: kDefaultButtonHeight,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kDefaultButtonRadius)
    )
);

final kDefaultElevatedButtomTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        primary: kDefaultColorScheme.primary,
        minimumSize: Size(kDefaultButtonMinWidth, kDefaultButtonHeight),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultButtonRadius)),
    )
);

// Bottom Navigation Bar
final kDefaultBottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: kDefaultColorScheme.background,
    selectedItemColor: kDefaultColorScheme.primaryVariant,
    unselectedItemColor: kDefaultThemeUnselectedButtonColor,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.shifting
);

// ThemeData
final kDefaultTheme = ThemeData(
    colorScheme: kDefaultColorScheme,
    iconTheme: kDefaultIconTheme,
    appBarTheme: kDefaultAppBarTheme,
    buttonTheme: kDefaultButtomTheme,
    elevatedButtonTheme: kDefaultElevatedButtomTheme,
    bottomNavigationBarTheme: kDefaultBottomNavigationBarTheme,
    scaffoldBackgroundColor: kDefaultColorScheme.background,
    dividerColor: kDefaultColorScheme.background
);

// Chat
final kDefaultChatAppBarTheme = ChatAppBarTheme();
final kDefaultChatBubbleTheme = ChatBubbleTheme(
    myBgColor: kDefaultColorScheme.primary,
    otherBgColor: kDefaultColorScheme.background,
    newDayTextStyle: TextStyle(
        color: kDefaultColorScheme.primary,
        fontSize: 22.0,
        fontFamily: "Qwigley"
    )
);
final kDefaultChatTextFieldTheme = ChatTextFieldTheme();
final kDefaultChatTheme = ChatTheme(
    appBarTheme: kDefaultChatAppBarTheme,
    bubbleTheme: kDefaultChatBubbleTheme,
    textFieldTheme: kDefaultChatTextFieldTheme
);

// App Theme
final kDefaultAppTheme = AppThemeData(
    colorPalette: kDefaultColorPalette,
    chatTheme: kDefaultChatTheme,
    themeData: kDefaultTheme
);
