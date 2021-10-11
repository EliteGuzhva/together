import 'package:flutter/material.dart';
import 'package:together/View/AppThemeData.dart';

import 'package:together/View/ChatTheme.dart';
import 'package:together/View/ColorPalette.dart';

// Colors
const kGruvboxMaterialDarkColorPalette = ColorPalette(
    background: const Color(0xff282828),
    foreground: const Color(0xffdfdfdf),
    black: const Color(0xff665c65),
    blackBright: const Color(0xff928374),
    red: const Color(0xffea6962),
    redBright: const Color(0xffea6962),
    green: const Color(0xffa9b665),
    greenBright: const Color(0xffa9b665),
    yellow: const Color(0xffe78a4e),
    yellowBright: const Color(0xffe3a84e),
    blue: const Color(0xff7daea3),
    blueBright: const Color(0xff7daea3),
    magenta: const Color(0xffd3869b),
    magentaBright: const Color(0xffd3869b),
    cyan: const Color(0xff89b482),
    cyanBright: const Color(0xff89b482),
    white: const Color(0xffdfdfdf),
    whiteBright: const Color(0xffdfdfdf)
);

final kGruvboxMaterialDarkColorScheme = ColorScheme.dark(
    primary: kGruvboxMaterialDarkColorPalette.blue,
    primaryVariant: kGruvboxMaterialDarkColorPalette.blueBright,
    secondary: kGruvboxMaterialDarkColorPalette.green,
    secondaryVariant: kGruvboxMaterialDarkColorPalette.greenBright,
    background: kGruvboxMaterialDarkColorPalette.background,
    surface: kGruvboxMaterialDarkColorPalette.foreground,
    error: kGruvboxMaterialDarkColorPalette.red,
    onPrimary: kGruvboxMaterialDarkColorPalette.foreground,
    onSecondary: kGruvboxMaterialDarkColorPalette.foreground,
    onError: kGruvboxMaterialDarkColorPalette.foreground,
    onBackground: kGruvboxMaterialDarkColorPalette.foreground,
    onSurface: kGruvboxMaterialDarkColorPalette.black
);

final kGruvboxMaterialDarkUnselectedButtonColor = kGruvboxMaterialDarkColorPalette.black;

// Icons
final kGruvboxMaterialDarkIconTheme =
    IconThemeData(color: kGruvboxMaterialDarkColorScheme.primaryVariant);

// AppBar
final kGruvboxMaterialDarkAppBarTitleTextStyle = TextStyle(
    color: kGruvboxMaterialDarkColorScheme.primary,
    fontFamily: "Qwigley",
    fontSize: 40.0
);

final kGruvboxMaterialDarkAppBarTheme = AppBarTheme(
    color: kGruvboxMaterialDarkColorScheme.background,
    titleTextStyle: kGruvboxMaterialDarkAppBarTitleTextStyle,
    iconTheme: kGruvboxMaterialDarkIconTheme
);

// Buttons
const kGruvboxMaterialDarkButtonMinWidth = 150.0;
const kGruvboxMaterialDarkButtonHeight = 40.0;
const kGruvboxMaterialDarkButtonRadius = 10.0;
final kGruvboxMaterialDarkButtonBackground = kGruvboxMaterialDarkColorScheme.primary;
final kGruvboxMaterialDarkButtonForeground = kGruvboxMaterialDarkColorScheme.onPrimary;

final kGruvboxMaterialDarkButtomTheme = ButtonThemeData(
    buttonColor: kGruvboxMaterialDarkButtonBackground,
    textTheme: ButtonTextTheme.primary,
    minWidth: kGruvboxMaterialDarkButtonMinWidth,
    height: kGruvboxMaterialDarkButtonHeight,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kGruvboxMaterialDarkButtonRadius)
    )
);

final kGruvboxMaterialDarkElevatedButtomTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        primary: kGruvboxMaterialDarkColorScheme.primary,
        minimumSize: Size(kGruvboxMaterialDarkButtonMinWidth, kGruvboxMaterialDarkButtonHeight),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kGruvboxMaterialDarkButtonRadius)),
    )
);

// Bottom Navigation Bar
final kGruvboxMaterialDarkBottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: kGruvboxMaterialDarkColorScheme.background,
    selectedItemColor: kGruvboxMaterialDarkColorScheme.primaryVariant,
    unselectedItemColor: kGruvboxMaterialDarkUnselectedButtonColor,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.shifting
);

// ThemeData
final kGruvboxMaterialDarkTheme = ThemeData(
    colorScheme: kGruvboxMaterialDarkColorScheme,
    textTheme: TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle()).apply(
        bodyColor: kGruvboxMaterialDarkColorPalette.foreground,
        displayColor: kGruvboxMaterialDarkColorPalette.foreground),
    iconTheme: kGruvboxMaterialDarkIconTheme,
    appBarTheme: kGruvboxMaterialDarkAppBarTheme,
    buttonTheme: kGruvboxMaterialDarkButtomTheme,
    elevatedButtonTheme: kGruvboxMaterialDarkElevatedButtomTheme,
    bottomNavigationBarTheme: kGruvboxMaterialDarkBottomNavigationBarTheme,
    scaffoldBackgroundColor: kGruvboxMaterialDarkColorScheme.background,
    dividerColor: kGruvboxMaterialDarkColorScheme.background
);

// Chat
final kGruvboxMaterialDarkChatAppBarTheme = ChatAppBarTheme();
final kGruvboxMaterialDarkChatBubbleTheme = ChatBubbleTheme(
    myBgColor: kGruvboxMaterialDarkColorScheme.primary,
    otherBgColor: kGruvboxMaterialDarkColorScheme.background,
    myFgColor:kGruvboxMaterialDarkColorPalette.background,
    otherFgColor:kGruvboxMaterialDarkColorPalette.foreground,
    myTimeColor: kGruvboxMaterialDarkColorPalette.black,
    otherTimeColor: kGruvboxMaterialDarkColorPalette.foreground,
    newDayTextStyle: TextStyle(
        color: kGruvboxMaterialDarkColorPalette.cyan,
        fontSize: 22.0,
        fontFamily: "Qwigley"
    )
);
final kGruvboxMaterialDarkChatTextFieldTheme = ChatTextFieldTheme();
final kGruvboxMaterialDarkChatTheme = ChatTheme(
    appBarTheme: kGruvboxMaterialDarkChatAppBarTheme,
    bubbleTheme: kGruvboxMaterialDarkChatBubbleTheme,
    textFieldTheme: kGruvboxMaterialDarkChatTextFieldTheme
);

// App Theme
final kGruvboxMaterialDarkAppTheme = AppThemeData(
    colorPalette: kGruvboxMaterialDarkColorPalette,
    chatTheme: kGruvboxMaterialDarkChatTheme,
    themeData: kGruvboxMaterialDarkTheme
);
