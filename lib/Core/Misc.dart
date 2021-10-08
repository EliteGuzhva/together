import 'package:flutter/services.dart';

String getTime(DateTime timestamp, {bool withSeconds=false}) {
  String hour = _twoDigitFormat(timestamp.hour);
  String minute = _twoDigitFormat(timestamp.minute);

  String result = hour + ":" + minute;

  if (withSeconds == true)
    {
      String second = _twoDigitFormat(timestamp.second);
      result = result + ":" + second;
    }

  return result;
}

int getDate(DateTime timestamp) {
  String year = timestamp.year.toString();
  String month = _twoDigitFormat(timestamp.month);
  String day = _twoDigitFormat(timestamp.day);
  String date = year + month + day;
  return int.parse(date);
}

String getFormattedDate(DateTime timestamp) {
  return _twoDigitFormat(timestamp.day) + "/"
      + _twoDigitFormat(timestamp.month) + "/"
      + timestamp.year.toString();
}

String _twoDigitFormat(int number) {
  return number > 9 ? number.toString() : "0$number";
}

void copyToClipboard(String text) {
  Clipboard.setData(new ClipboardData(text: text));
}
