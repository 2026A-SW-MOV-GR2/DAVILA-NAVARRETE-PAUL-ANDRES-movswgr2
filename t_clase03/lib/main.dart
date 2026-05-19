import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/models.dart';
import 'src/widgets/header_card.dart';
import 'src/widgets/item_card.dart';
import 'src/crud_form.dart';

void main() {
  runApp(const MyApp());
}

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cómics Store',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6D28D9),
        scaffoldBackgroundColor: const Color(0xFFFAF5FF),
      ),
      home: const CrudHomePage(),
    );
  }
}

class CrudHomePage extends StatefulWidget {
  const CrudHomePage({super.key});

  @override
  State<CrudHomePage> createState() => _CrudHomePageState();
}

class _CrudHomePageState extends State<CrudHomePage> {
  final List<CrudItem> _items = [
    CrudItem(
      id: 1,
      title: 'Watchmen',
      subtitle: 'Alan Moore & Dave Gibbons',
      category: 'Nuevo',
      date: DateTime(2026, 1, 12),
      enabled: true,
      color: const Color(0xFF6D28D9),
    ),
    CrudItem(
      id: 2,
      title: 'The Sandman Vol. 1',
      subtitle: 'Neil Gaiman',
      category: 'Usado',
      date: DateTime(2026, 1, 18),
      enabled: true,
      color: const Color(0xFF7C3AED),
    ),
    CrudItem(
      id: 3,
      title: 'V for Vendetta',
      subtitle: 'Alan Moore & David Lloyd',
      category: 'Nuevo',
      date: DateTime(2026, 2, 2),
      enabled: true,
      color: const Color(0xFFEAB308),
    ),
  ];

  int _nextId = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF4F7FB), Color(0xFFE7F0F8), Color(0xFFF9FAFB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: HeaderCard(
                    totalItems: _items.length,
                    onCreate: () => _openForm(),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList.separated(
                  itemCount: _items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ItemCard(
                      item: item,
                      onEdit: () => _openForm(existing: item),
                      onDelete: () => _confirmDelete(item),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo cómic'),
      ),
    );
  }

  Future<void> _openForm({CrudItem? existing}) async {
    final result = await Navigator.of(context).push<CrudFormResult>(
      MaterialPageRoute(builder: (_) => CrudFormPage(item: existing)),
    );

    if (result == null) return;

    setState(() {
      if (result.isEditing) {
        final index = _items.indexWhere((element) => element.id == result.item.id);
        if (index != -1) {
          _items[index] = result.item;
        }
      } else {
        _items.insert(0, result.item.copyWith(id: _nextId++));
      }
    });

    if (!mounted) return;

    final msg = result.isEditing ? 'Cómic actualizado' : 'Cómic añadido';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _confirmDelete(CrudItem item) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar cómic'),
        content: Text('¿Quieres quitar "${item.title}" del inventario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    ).then((shouldDelete) async {
      if (shouldDelete != true) return;

      setState(() {
        _items.removeWhere((element) => element.id == item.id);
      });

      final msg = '"${item.title}" removido del inventario';
      if (Platform.isAndroid) {
        // Fire-and-forget native Toast (no await, no SnackBar fallback)
        NativeFeedback.showToast(msg);
      } else {
        // iOS: use SnackBar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
      }
    });
  }
}

