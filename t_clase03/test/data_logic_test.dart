import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:t_clase03/src/data/database_mode.dart';
import 'package:t_clase03/src/data/database_provider.dart';
import 'package:t_clase03/src/models.dart';
import 'package:t_clase03/src/providers/crud_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Logical data layer', () {
    test('saves items in SQL mode with generated ids', () async {
      final provider = DatabaseProvider();
      final controller = CrudController(provider);

      await controller.refresh();

      final created = await controller.saveItem(
        CrudItem(
          id: 0,
          title: 'Prueba SQL',
          subtitle: 'Escritura lógica',
          category: 'Nuevo',
          date: DateTime(2026, 5, 30),
          enabled: true,
          color: const Color(0xFF2563EB),
        ),
        isEditing: false,
      );

      expect(created.id, greaterThan(0));
      expect(controller.items.any((item) => item.id == created.id), isTrue);
      expect(controller.items.first.title, 'Prueba SQL');

      controller.dispose();
      provider.dispose();
    });

    test('switches engine and reloads the active repository data', () async {
      final provider = DatabaseProvider();
      final controller = CrudController(provider);

      await controller.refresh();

      final sqlItem = await controller.saveItem(
        CrudItem(
          id: 0,
          title: 'Solo SQL',
          subtitle: 'Debe vivir en SQLite',
          category: 'Nuevo',
          date: DateTime(2026, 5, 30),
          enabled: true,
          color: const Color(0xFF7C3AED),
        ),
        isEditing: false,
      );

      expect(controller.items.any((item) => item.id == sqlItem.id), isTrue);

      provider.toggleMode(true);
      await controller.refresh();

      expect(controller.currentMode, DatabaseMode.nosql);
      expect(controller.currentModeLabel, 'NoSQL');
      expect(controller.items.isNotEmpty, isTrue);
      expect(controller.items.any((item) => item.id == sqlItem.id), isFalse);

      provider.toggleMode(false);
      await controller.refresh();

      expect(controller.currentMode, DatabaseMode.sql);
      expect(controller.currentModeLabel, 'SQL');
      expect(controller.items.any((item) => item.id == sqlItem.id), isTrue);

      controller.dispose();
      provider.dispose();
    });
  });
}