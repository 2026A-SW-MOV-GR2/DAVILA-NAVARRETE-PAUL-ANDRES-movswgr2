import 'package:flutter/material.dart';
import 'models.dart';

class CrudFormPage extends StatefulWidget {
  const CrudFormPage({super.key, this.item});

  final CrudItem? item;

  @override
  State<CrudFormPage> createState() => _CrudFormPageState();
}

class _CrudFormPageState extends State<CrudFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _categoryController;
  late DateTime _selectedDate;
  late bool _enabled;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = TextEditingController(text: item?.title ?? '');
    _subtitleController = TextEditingController(text: item?.subtitle ?? '');
    _categoryController = TextEditingController(text: item?.category ?? 'Nuevo');
    _selectedDate = item?.date ?? DateTime(2026, 3, 5);
    _enabled = item?.enabled ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar cómic' : 'Nuevo cómic'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Actualiza los datos del cómic' : 'Registra un nuevo cómic',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título del cómic',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el título del cómic';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subtitleController,
                  decoration: const InputDecoration(
                    labelText: 'Autor/Editorial',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa una descripción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _categoryController.text.isEmpty ? 'Nuevo' : _categoryController.text,
                  items: const [
                    DropdownMenuItem(value: 'Nuevo', child: Text('Nuevo')),
                    DropdownMenuItem(value: 'Usado', child: Text('Usado')),
                  ],
                  onChanged: (value) {
                    if (value != null) _categoryController.text = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Estado del cómic',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fecha de adquisición'),
                  subtitle: Text(formatDate(_selectedDate)),
                  trailing: OutlinedButton(
                    onPressed: _pickDate,
                    child: const Text('Elegir fecha'),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _enabled,
                  onChanged: (value) => setState(() => _enabled = value),
                  title: const Text('Disponible para venta'),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(isEditing ? 'Actualizar cómic' : 'Registrar cómic'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      initialDate: _selectedDate,
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final item = CrudItem(
      id: widget.item?.id ?? -1,
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      category: _categoryController.text.trim().isEmpty ? 'Nuevo' : _categoryController.text.trim(),
      date: _selectedDate,
      enabled: _enabled,
      color: widget.item?.color ?? const Color(0xFF6D28D9),
    );

    Navigator.of(context).pop(
      CrudFormResult(
        item: item,
        isEditing: widget.item != null,
      ),
    );
  }
}
