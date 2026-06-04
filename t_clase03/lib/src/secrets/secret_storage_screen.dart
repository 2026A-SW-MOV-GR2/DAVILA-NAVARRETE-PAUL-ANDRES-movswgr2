import 'package:flutter/material.dart';

import 'datastore_service.dart';
import 'encrypted_preferences_service.dart';
import 'secret_storage_service.dart';
import 'shared_preferences_service.dart';

enum SecretStorageBackend {
  sharedPreferences,
  dataStore,
  encryptedSharedPreferences,
}

class SecretStorageScreen extends StatefulWidget {
  const SecretStorageScreen({super.key});

  @override
  State<SecretStorageScreen> createState() => _SecretStorageScreenState();
}

class _SecretStorageScreenState extends State<SecretStorageScreen> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  SecretStorageBackend _selectedBackend = SecretStorageBackend.sharedPreferences;
  String _resultMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  SecretStorageService get _service {
    switch (_selectedBackend) {
      case SecretStorageBackend.sharedPreferences:
        return SharedPreferencesService();
      case SecretStorageBackend.dataStore:
        return DataStoreService();
      case SecretStorageBackend.encryptedSharedPreferences:
        return EncryptedPreferencesService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SecretStorageScreen')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gestión de secretos y configuración',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _keyController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Llave',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _valueController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<SecretStorageBackend>(
                value: _selectedBackend,
                decoration: const InputDecoration(
                  labelText: 'Selector',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: SecretStorageBackend.sharedPreferences,
                    child: Text('SharedPreferences'),
                  ),
                  DropdownMenuItem(
                    value: SecretStorageBackend.dataStore,
                    child: Text('DataStore'),
                  ),
                  DropdownMenuItem(
                    value: SecretStorageBackend.encryptedSharedPreferences,
                    child: Text('EncryptedSharedPreferences'),
                  ),
                ],
                onChanged: _isLoading
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _selectedBackend = value);
                        }
                      },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _isLoading ? null : _save,
                      child: const Text('Guardar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _read,
                      child: const Text('Recuperar'),
                    ),
                  ),
                ],
              ),
              if (_isLoading) ...[
                const SizedBox(height: 16),
                const LinearProgressIndicator(),
              ],
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  _resultMessage.isEmpty ? 'El resultado aparecerá aquí.' : _resultMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final key = _keyController.text.trim();
    final value = _valueController.text.trim();

    if (key.isEmpty || value.isEmpty) {
      setState(() {
        _resultMessage = 'Llave y valor son obligatorios.';
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _service.save(key, value);
      if (!mounted) {
        return;
      }

      setState(() {
        _resultMessage = 'Valor guardado correctamente.';
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Se guardó el valor.')));
    } catch (error) {
      if (mounted) {
        setState(() {
          _resultMessage = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _read() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      setState(() {
        _resultMessage = 'Ingresa una llave para recuperar.';
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final value = await _service.read(key);
      if (!mounted) {
        return;
      }

      setState(() {
        if (value == null) {
          _resultMessage = 'No se encontró la llave.';
        } else {
          _valueController.text = value;
          _resultMessage = 'Valor recuperado correctamente.';
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _resultMessage = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
