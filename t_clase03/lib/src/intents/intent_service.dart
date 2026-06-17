import 'dart:async';

import 'package:flutter/services.dart';

class IntentService {
  IntentService._();
  static final IntentService instance = IntentService._();

  static const _channel = MethodChannel('t_clase03/intents');
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  bool _initialized = false;

  // Último dato recibido (texto o imagen); lo lee IncomingIntentsTab al abrirse
  Map<String, dynamic>? latest;

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void init() {
    if (_initialized) return;
    _initialized = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onSharedData') {
        final data = Map<String, dynamic>.from(call.arguments as Map);
        latest = data;
        _controller.add(data);
      }
    });
  }

  Future<Map<String, dynamic>?> fetchInitial() async {
    final result = await _channel.invokeMethod<Map>('getInitialIntent');
    if (result == null) return null;
    final data = Map<String, dynamic>.from(result);
    latest = data;
    return data;
  }
}
