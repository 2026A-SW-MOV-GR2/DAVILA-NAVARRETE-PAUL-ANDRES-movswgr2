import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../crud_form.dart';
import '../data/database_mode.dart';
import '../data/database_provider.dart';
import '../models.dart';
import '../native_feedback.dart';
import '../network/network_screen.dart';
import '../providers/crud_controller.dart';
import '../secrets/secret_storage_screen.dart';
import '../widgets/header_card.dart';
import '../widgets/item_card.dart';

class CrudHomePage extends StatefulWidget {
  const CrudHomePage({super.key});

  @override
  State<CrudHomePage> createState() => _CrudHomePageState();
}

class _CrudHomePageState extends State<CrudHomePage> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CrudController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cómics Store'),
        actions: [
          IconButton(
            onPressed: _openNetworkScreen,
            icon: const Icon(Icons.cloud_outlined),
            tooltip: 'NetworkScreen',
          ),
          IconButton(
            onPressed: _openSecretStorageScreen,
            icon: const Icon(Icons.key_outlined),
            tooltip: 'SecretStorageScreen',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SQL',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: controller.currentMode == DatabaseMode.sql ? Colors.black87 : Colors.black45,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Switch(
                  value: controller.currentMode == DatabaseMode.nosql,
                  onChanged: (value) => context.read<DatabaseProvider>().toggleMode(value),
                ),
                Text(
                  'NoSQL',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: controller.currentMode == DatabaseMode.nosql ? Colors.black87 : Colors.black45,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                    totalItems: controller.items.length,
                    databaseLabel: controller.currentModeLabel,
                    databaseColor: controller.currentModeColor,
                    onCreate: () => _openForm(),
                  ),
                ),
              ),
              if (controller.isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: LinearProgressIndicator(),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                sliver: SliverList.separated(
                  itemCount: controller.items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
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

    if (result == null) {
      return;
    }

    final controller = context.read<CrudController>();
    await controller.saveItem(result.item, isEditing: result.isEditing);

    if (!mounted) {
      return;
    }

    final message = result.isEditing ? 'Cómic actualizado' : 'Cómic añadido';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmDelete(CrudItem item) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar cómic'),
        content: Text('¿Quieres quitar "${item.title}" del inventario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) {
      return;
    }

    final controller = context.read<CrudController>();
    await controller.deleteItem(item);

    final msg = '"${item.title}" removido del inventario';
    if (Theme.of(context).platform == TargetPlatform.android) {
      await NativeFeedback.showToast(msg);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _openNetworkScreen() {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NetworkScreen()),
    );
  }

  Future<void> _openSecretStorageScreen() {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SecretStorageScreen()),
    );
  }
}
