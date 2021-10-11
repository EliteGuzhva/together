import 'package:flutter/material.dart';

class ChatAppBarTheme {
  final double height;

  ChatAppBarTheme({this.height = 55.0});
}

class ChatBubbleTheme {
  final Color myBgColor;
  final Color otherBgColor;
  final Color selectedBgColor;
  final Color myFgColor;
  final Color otherFgColor;
  final Color myTimeColor;
  final Color otherTimeColor;

  final CrossAxisAlignment myAlignment;
  final CrossAxisAlignment otherAlignment;

  final IconData loadingIcon;
  final IconData sentIcon;
  final IconData deliveredIcon;

  final double radius;

  final TextStyle newDayTextStyle;

  ChatBubbleTheme(
      {this.myBgColor = Colors.blue,
      this.otherBgColor = Colors.white,
      this.selectedBgColor = Colors.blueGrey,
      this.myFgColor = Colors.white,
      this.otherFgColor = Colors.black,
      this.myTimeColor = Colors.white70,
      this.otherTimeColor = Colors.black38,
      this.myAlignment = CrossAxisAlignment.end,
      this.otherAlignment = CrossAxisAlignment.start,
      this.loadingIcon = Icons.access_time,
      this.sentIcon = Icons.done,
      this.deliveredIcon = Icons.done_all,
      this.radius = 20.0,
      this.newDayTextStyle =
          const TextStyle(color: Colors.blue, fontSize: 22.0)});
}

class ChatTextFieldTheme {
  final String hintText;

  final IconData attachIcon;
  final IconData sendIcon;

  ChatTextFieldTheme(
      {this.hintText = "Напиши мне что-нибудь",
      this.attachIcon = Icons.attach_file,
      this.sendIcon = Icons.send});
}

class ChatTheme {
  final ChatAppBarTheme appBarTheme;
  final ChatBubbleTheme bubbleTheme;
  final ChatTextFieldTheme textFieldTheme;

  ChatTheme({
    @required this.appBarTheme,
    @required this.bubbleTheme,
    @required this.textFieldTheme});
}
