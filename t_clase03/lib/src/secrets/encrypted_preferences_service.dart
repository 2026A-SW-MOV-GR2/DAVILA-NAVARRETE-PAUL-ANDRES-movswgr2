import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secret_storage_service.dart';

class EncryptedPreferencesService implements SecretStorageService {
  EncryptedPreferencesService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  @override
  Future<void> save(String key, String value) {
    return _storage.write(key: key, value: value);
  }
}
