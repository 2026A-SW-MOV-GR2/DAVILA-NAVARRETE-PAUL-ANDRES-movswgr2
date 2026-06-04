import 'package:shared_preferences/shared_preferences.dart';

import 'secret_storage_service.dart';

class SharedPreferencesService implements SecretStorageService {
  @override
  Future<String?> read(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  @override
  Future<void> save(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }
}
