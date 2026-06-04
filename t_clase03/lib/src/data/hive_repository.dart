import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import 'app_logger.dart';
import '../models.dart';
import 'item_repository.dart';

class HiveRepository implements ItemRepository {
  static const String _boxName = 'crud_items_box';
  Box<String>? _box;
  bool _fallbackMode = false;
  List<CrudItem> _fallbackItems = defaultCrudItems();

  Future<Box<String>?> _openBox() async {
    if (_fallbackMode) {
      return null;
    }

    if (_box != null && _box!.isOpen) {
      return _box;
    }

    try {
      if (Hive.isBoxOpen(_boxName)) {
        _box = Hive.box<String>(_boxName);
      } else {
        _box = await Hive.openBox<String>(_boxName);
      }

      if (_box!.isEmpty) {
        for (final item in defaultCrudItems()) {
          await _box!.put(item.id.toString(), jsonEncode(item.toMap()));
        }
      }

      return _box;
    } catch (_) {
      _fallbackMode = true;
      AppLogger.error('HiveRepository', 'Hive unavailable, using in-memory fallback');
      return null;
    }
  }

  CrudItem _fromStoredValue(String value) {
    return CrudItem.fromMap(jsonDecode(value) as Map<String, dynamic>);
  }

  String _toStoredValue(CrudItem item) {
    return jsonEncode(item.toMap());
  }

  @override
  Future<List<CrudItem>> listItems() async {
    final box = await _openBox();
    if (box == null) {
      AppLogger.error('HiveRepository', 'Hive unavailable, using in-memory fallback for listItems');
      return List<CrudItem>.from(_fallbackItems);
    }

    final items = box.values.map(_fromStoredValue).toList();
    items.sort((left, right) => right.id.compareTo(left.id));
    return items;
  }

  @override
  Future<CrudItem> createItem(CrudItem item) async {
    final box = await _openBox();
    if (box == null) {
      final nextId = _fallbackItems.isEmpty ? 1 : _fallbackItems.map((element) => element.id).reduce((a, b) => a > b ? a : b) + 1;
      final created = item.copyWith(id: nextId);
      _fallbackItems = [created, ..._fallbackItems];
      AppLogger.info('HiveRepository', 'Inserted fallback item id=${created.id} title="${created.title}"');
      return created;
    }

    final nextId = box.values.isEmpty
        ? 1
        : box.values
                .map((value) => _fromStoredValue(value).id)
                .reduce((left, right) => left > right ? left : right) +
            1;
    final created = item.copyWith(id: nextId);
    await box.put(created.id.toString(), _toStoredValue(created));
    AppLogger.info('HiveRepository', 'Inserted item id=${created.id} title="${created.title}"');
    return created;
  }

  @override
  Future<CrudItem> updateItem(CrudItem item) async {
    final box = await _openBox();
    if (box == null) {
      _fallbackItems = _fallbackItems.map((element) => element.id == item.id ? item : element).toList();
      AppLogger.info('HiveRepository', 'Updated fallback item id=${item.id}');
      return item;
    }

    await box.put(item.id.toString(), _toStoredValue(item));
    AppLogger.info('HiveRepository', 'Updated item id=${item.id}');
    return item;
  }

  @override
  Future<void> deleteItem(int id) async {
    final box = await _openBox();
    if (box == null) {
      _fallbackItems.removeWhere((element) => element.id == id);
      AppLogger.info('HiveRepository', 'Deleted fallback item id=$id');
      return;
    }

    await box.delete(id.toString());
    AppLogger.info('HiveRepository', 'Deleted item id=$id');
  }
}
