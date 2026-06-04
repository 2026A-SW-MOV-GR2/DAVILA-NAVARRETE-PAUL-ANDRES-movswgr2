import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'secret_storage_service.dart';
import 'shared_preferences_service.dart';

class DataStoreService implements SecretStorageService {
  DataStoreService({SecretStorageService? fallbackService})
      : _fallbackService = fallbackService ?? SharedPreferencesService();

  final SecretStorageService _fallbackService;
  static const MethodChannel _channel = MethodChannel('t_clase03/datastore');

  @override
  Future<String?> read(String key) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return _fallbackService.read(key);
    }

    try {
      final value = await _channel.invokeMethod<String>('read', {'key': key});
      return value;
    } on MissingPluginException {
      return _fallbackService.read(key);
    }
  }

  @override
  Future<void> save(String key, String value) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      await _fallbackService.save(key, value);
      return;
    }

    try {
      await _channel.invokeMethod<void>('save', {'key': key, 'value': value});
    } on MissingPluginException {
      await _fallbackService.save(key, value);
    }
  }
}
