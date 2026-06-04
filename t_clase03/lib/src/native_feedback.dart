import 'dart:async';

import 'package:flutter/services.dart';

class NativeFeedback {
  static const MethodChannel _channel = MethodChannel('t_clase03/toast');

  static Future<void> showToast(String message) async {
    try {
      await _channel.invokeMethod('showToast', {'message': message});
    } on PlatformException {
      // ignore: no-op fallback
    }
  }
}
