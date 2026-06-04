import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/app_logger.dart';
import '../data/database_provider.dart';
import '../data/database_mode.dart';
import '../models.dart';

class CrudController extends ChangeNotifier {
  CrudController(this._databaseProvider) {
    _databaseProvider.addListener(_handleDatabaseChange);
    unawaited(refresh());
  }

  final DatabaseProvider _databaseProvider;

  List<CrudItem> _items = defaultCrudItems();
  bool _isLoading = false;

  List<CrudItem> get items => List.unmodifiable(_items);

  bool get isLoading => _isLoading;

  DatabaseMode get currentMode => _databaseProvider.currentMode;

  String get currentModeLabel => _databaseProvider.currentModeLabel;

  Color get currentModeColor => _databaseProvider.currentModeColor;

  Future<void> refresh() async {
    AppLogger.debug('CrudController', 'Refreshing items for $currentModeLabel');
    _setLoading(true);
    try {
      final repository = _databaseProvider.currentRepository;
      final loadedItems = await repository.listItems();
      _items = loadedItems.isEmpty ? defaultCrudItems() : loadedItems;
      AppLogger.info('CrudController', 'Loaded ${_items.length} items from $currentModeLabel');
    } catch (_) {
      AppLogger.error('CrudController', 'Failed to refresh items from $currentModeLabel');
      _items = defaultCrudItems();
    } finally {
      _setLoading(false);
    }
  }

  Future<CrudItem> saveItem(CrudItem item, {required bool isEditing}) async {
    final operation = isEditing ? 'update' : 'insert';
    AppLogger.debug('CrudController', 'Starting $operation on $currentModeLabel for itemId=${item.id}');
    _setLoading(true);
    try {
      final repository = _databaseProvider.currentRepository;
      final persistedItem = isEditing && item.id > 0 ? await repository.updateItem(item) : await repository.createItem(item);

      if (isEditing && item.id > 0) {
        _items = _items.map((element) => element.id == persistedItem.id ? persistedItem : element).toList();
      } else {
        _items = [persistedItem, ..._items.where((element) => element.id != persistedItem.id)];
      }

      AppLogger.info('CrudController', '${operation.toUpperCase()} completed on $currentModeLabel for itemId=${persistedItem.id}');

      return persistedItem;
    } catch (_) {
      AppLogger.error('CrudController', 'Failed to $operation item on $currentModeLabel', item.id);
      if (isEditing && item.id > 0) {
        _items = _items.map((element) => element.id == item.id ? item : element).toList();
      } else {
        final nextId = _items.isEmpty ? 1 : _items.map((element) => element.id).reduce((left, right) => left > right ? left : right) + 1;
        final created = item.copyWith(id: nextId);
        _items = [created, ..._items];
        AppLogger.info('CrudController', 'Fallback insert applied with generated id=$nextId');
        return created;
      }

      return item;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteItem(CrudItem item) async {
    AppLogger.debug('CrudController', 'Starting delete on $currentModeLabel for itemId=${item.id}');
    _setLoading(true);
    try {
      await _databaseProvider.currentRepository.deleteItem(item.id);
      _items = _items.where((element) => element.id != item.id).toList();
      AppLogger.info('CrudController', 'Delete completed on $currentModeLabel for itemId=${item.id}');
    } catch (_) {
      AppLogger.error('CrudController', 'Failed to delete item on $currentModeLabel', item.id);
      _items = _items.where((element) => element.id != item.id).toList();
    } finally {
      _setLoading(false);
    }
  }

  void _handleDatabaseChange() {
    unawaited(refresh());
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }

    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _databaseProvider.removeListener(_handleDatabaseChange);
    super.dispose();
  }
}
