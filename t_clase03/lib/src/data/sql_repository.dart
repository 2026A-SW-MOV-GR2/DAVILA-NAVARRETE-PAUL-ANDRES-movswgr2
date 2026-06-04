import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'app_logger.dart';
import '../models.dart';
import 'item_repository.dart';

class SqlRepository implements ItemRepository {
  static const String _tableName = 'crud_items';
  Database? _database;
  bool _fallbackMode = false;
  List<CrudItem> _fallbackItems = defaultCrudItems();

  Future<Database?> _openDatabase() async {
    if (_fallbackMode) {
      return null;
    }

    if (_database != null) {
      return _database;
    }

    try {
      final databasePath = await getDatabasesPath();
      final path = p.join(databasePath, 't_clase03.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (database, version) async {
          AppLogger.info('SqlRepository', 'Creating SQLite schema at $path');
          await database.execute('''
            CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              subtitle TEXT NOT NULL,
              category TEXT NOT NULL,
              date INTEGER NOT NULL,
              enabled INTEGER NOT NULL,
              color INTEGER NOT NULL
            )
          ''');

          for (final item in defaultCrudItems()) {
            await database.insert(_tableName, _toSqlMap(item));
          }
          AppLogger.debug('SqlRepository', 'Seeded SQLite database with ${defaultCrudItems().length} items');
        },
      );

      return _database;
    } catch (_) {
      _fallbackMode = true;
      return null;
    }
  }

  Map<String, Object?> _toSqlMap(CrudItem item) {
    return {
      'id': item.id,
      'title': item.title,
      'subtitle': item.subtitle,
      'category': item.category,
      'date': item.date.millisecondsSinceEpoch,
      'enabled': item.enabled ? 1 : 0,
      'color': item.color.value,
    };
  }

  CrudItem _fromSqlMap(Map<String, Object?> map) {
    return CrudItem(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      category: map['category'] as String? ?? 'Nuevo',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int? ?? DateTime.now().millisecondsSinceEpoch),
      enabled: (map['enabled'] as int? ?? 1) == 1,
      color: Color(map['color'] as int? ?? 0xFF6D28D9),
    );
  }

  @override
  Future<List<CrudItem>> listItems() async {
    final database = await _openDatabase();
    if (database == null) {
      AppLogger.error('SqlRepository', 'SQLite unavailable, using in-memory fallback for listItems');
      return List<CrudItem>.from(_fallbackItems);
    }

    final rows = await database.query(_tableName, orderBy: 'id DESC');
    if (rows.isEmpty) {
      for (final item in defaultCrudItems()) {
        await database.insert(_tableName, _toSqlMap(item));
      }
      final seededRows = await database.query(_tableName, orderBy: 'id DESC');
      return seededRows.map(_fromSqlMap).toList();
    }

    return rows.map(_fromSqlMap).toList();
  }

  @override
  Future<CrudItem> createItem(CrudItem item) async {
    final database = await _openDatabase();
    if (database == null) {
      final nextId = _fallbackItems.isEmpty ? 1 : _fallbackItems.map((element) => element.id).reduce((a, b) => a > b ? a : b) + 1;
      final created = item.copyWith(id: nextId);
      _fallbackItems = [created, ..._fallbackItems];
      AppLogger.info('SqlRepository', 'Inserted fallback item id=${created.id} title="${created.title}"');
      return created;
    }

    final id = await database.insert(_tableName, _toSqlMap(item)..remove('id'));
    AppLogger.info('SqlRepository', 'Inserted item id=$id title="${item.title}"');
    return item.copyWith(id: id);
  }

  @override
  Future<CrudItem> updateItem(CrudItem item) async {
    final database = await _openDatabase();
    if (database == null) {
      _fallbackItems = _fallbackItems.map((element) => element.id == item.id ? item : element).toList();
      AppLogger.info('SqlRepository', 'Updated fallback item id=${item.id}');
      return item;
    }

    await database.update(
      _tableName,
      _toSqlMap(item)..remove('id'),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    AppLogger.info('SqlRepository', 'Updated item id=${item.id}');
    return item;
  }

  @override
  Future<void> deleteItem(int id) async {
    final database = await _openDatabase();
    if (database == null) {
      _fallbackItems.removeWhere((element) => element.id == id);
      AppLogger.info('SqlRepository', 'Deleted fallback item id=$id');
      return;
    }

    await database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    AppLogger.info('SqlRepository', 'Deleted item id=$id');
  }
}
