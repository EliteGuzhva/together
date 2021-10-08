import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

void vibrate(FeedbackType type) async {
  bool canVibrate = await Vibrate.canVibrate;
  if (canVibrate) {
    Vibrate.feedback(type);
  }
}

void unfocus(BuildContext context) {
  FocusScope.of(context).requestFocus(new FocusNode());
}

void scrollToBottom(ScrollController scrollController) {
  scrollController.animateTo(0.0,
      duration: Duration(milliseconds: 300), curve: Curves.easeOut);
}

void pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    CupertinoPageRoute<void>(
        builder: (_) => page),
  );
}

void pushReplacePage(BuildContext context, Widget page) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(
        builder: (_) => page),
  );
}

void pop(BuildContext context) {
  Navigator.of(context).pop();
}

void showSnack(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(SnackBar
    (content: Text(message)));
}
