import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'app_logger.dart';
import '../models.dart';
import 'database_mode.dart';
import 'hive_repository.dart';
import 'item_repository.dart';
import 'sql_repository.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseProvider()
      : _sqlRepository = SqlRepository(),
        _hiveRepository = HiveRepository();

  final SqlRepository _sqlRepository;
  final HiveRepository _hiveRepository;

  DatabaseMode _currentMode = DatabaseMode.sql;

  DatabaseMode get currentMode => _currentMode;

  String get currentModeLabel => _currentMode == DatabaseMode.sql ? 'SQL' : 'NoSQL';

  Color get currentModeColor => _currentMode == DatabaseMode.sql ? const Color(0xFF1D4ED8) : const Color(0xFF059669);

  ItemRepository get currentRepository => _currentMode == DatabaseMode.sql ? _sqlRepository : _hiveRepository;

  void setMode(DatabaseMode mode) {
    if (_currentMode == mode) {
      return;
    }

    _currentMode = mode;
    AppLogger.info('DatabaseProvider', 'Database mode changed to $currentModeLabel');
    notifyListeners();
  }

  void toggleMode(bool useNoSql) {
    setMode(useNoSql ? DatabaseMode.nosql : DatabaseMode.sql);
  }
}
