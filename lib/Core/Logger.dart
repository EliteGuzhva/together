import 'package:together/Core/FileIO.dart';
import 'package:together/Core/Misc.dart';
import 'package:flutter/foundation.dart' as Foundation;

enum LogLevel
{
  DEBUG,
  ERROR
}

class Logger
{
  //! @brief Create singleton
  static final Logger _singleton = new Logger._internal();
  Logger._internal();
  static Logger getInstance() => _singleton;

  final _fio = FileIO();

  String write(String owner, String logText, String logName, LogLevel logLevel)
  {
    DateTime timestamp = DateTime.now();
    String date = getFormattedDate(timestamp);
    String time = getTime(timestamp, withSeconds: true);
    String text = logLevel.toString()
        + " [" + date + " - " + time + "] - "
        + owner + ": " + logText + "\n";
    _fio.append(logName + ".txt", text);

    return text;
  }
}

//! @brief public functions to write logs
//!        without instantiating new Logger objects
const String mainLog = "logs";


void logDebug(String owner, String logText, { String logName = mainLog })
{
  if (Foundation.kDebugMode) {
    owner = owner.replaceAll(RegExp('Instance of '), '');
    owner = owner.replaceAll(RegExp("'"), "");

    String text = Logger.getInstance()
        .write(owner, logText, logName, LogLevel.DEBUG);
    print(text);
  }
}

void logError(String owner, String logText, { String logName = mainLog })
{
  String text = Logger.getInstance()
      .write(owner, logText, logName, LogLevel.ERROR);
  print(text);
}
