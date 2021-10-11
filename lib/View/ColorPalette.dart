import 'package:flutter/material.dart';

@immutable
class ColorPalette {
  final Color background;
  final Color foreground;
  final Color black;
  final Color red;
  final Color green;
  final Color yellow;
  final Color blue;
  final Color magenta;
  final Color cyan;
  final Color white;
  final Color blackBright;
  final Color redBright;
  final Color greenBright;
  final Color yellowBright;
  final Color blueBright;
  final Color magentaBright;
  final Color cyanBright;
  final Color whiteBright;

  const ColorPalette(
      {Key key,
      this.background,
      this.foreground,
      this.black,
      this.red,
      this.green,
      this.yellow,
      this.blue,
      this.magenta,
      this.cyan,
      this.white,
      this.blackBright,
      this.redBright,
      this.greenBright,
      this.yellowBright,
      this.blueBright,
      this.magentaBright,
      this.cyanBright,
      this.whiteBright});

  Color getColorByName(String name) {
    if (name == "Red")
      return red;
    else if (name == "Green")
      return green;
    else if (name == "Yellow")
      return yellow;
    else if (name == "Blue")
      return blue;
    else if (name == "Magenta")
      return magenta;
    else if (name == "Cyan")
      return cyan;
    else if (name == "White")
      return white;
    else if (name == "Black")
      return black;
    else
      return white;
  }
}
