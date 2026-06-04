import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  error,
}

class AppLogger {
  static void debug(String tag, String message) {
    _log(LogLevel.debug, tag, message);
  }

  static void info(String tag, String message) {
    _log(LogLevel.info, tag, message);
  }

  static void error(String tag, String message, [Object? error]) {
    final suffix = error == null ? '' : ' | error=$error';
    _log(LogLevel.error, tag, '$message$suffix');
  }

  static void _log(LogLevel level, String tag, String message) {
    debugPrint('${level.name.toUpperCase()} [$tag] $message');
  }
}
