import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'intent_service.dart';

class IncomingIntentsTab extends StatefulWidget {
  const IncomingIntentsTab({super.key});

  @override
  State<IncomingIntentsTab> createState() => _IncomingIntentsTabState();
}

class _IncomingIntentsTabState extends State<IncomingIntentsTab> {
  String? _receivedText;
  Uint8List? _receivedImageBytes;
  bool _waiting = true;
  StreamSubscription<Map<String, dynamic>>? _sub;

  @override
  void initState() {
    super.initState();
    // Mostrar dato ya recibido (si home_screen navegó aquí con data pendiente)
    final latest = IntentService.instance.latest;
    if (latest != null) _processData(latest);

    // Escuchar nuevos datos mientras la pantalla está abierta
    _sub = IntentService.instance.stream.listen(_processData);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _processData(Map<String, dynamic> data) {
    final type = data['type'] as String;
    if (type == 'text') {
      if (mounted) {
        setState(() {
          _receivedText = data['data'] as String;
          _receivedImageBytes = null;
          _waiting = false;
        });
      }
    } else if (type == 'image') {
      final raw = data['data'];
      final bytes = raw is Uint8List
          ? raw
          : Uint8List.fromList((raw as List).cast<int>());
      if (mounted) {
        setState(() {
          _receivedImageBytes = bytes;
          _receivedText = null;
          _waiting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'MÓDULO: INTENTS ENTRANTES',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(height: 24),

          if (_waiting)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.hourglass_empty, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(
                      'Estado: Esperando datos externos...',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Zona de texto
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.text_fields,
                          size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Texto recibido',
                          style: theme.textTheme.labelLarge),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _receivedImageBytes != null
                          ? '[ Dato actual: archivo binario (imagen) ]'
                          : (_receivedText ?? 'Sin texto recibido'),
                      style: _receivedImageBytes != null
                          ? theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            )
                          : theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Zona de imagen
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.image_outlined,
                          size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Imagen recibida',
                          style: theme.textTheme.labelLarge),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: theme.colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(8),
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _receivedImageBytes != null
                        ? Image.memory(_receivedImageBytes!,
                            fit: BoxFit.contain)
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image,
                                    size: 48,
                                    color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                Text(
                                  'Contenedor Dinámico para Imagen Recibida',
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
