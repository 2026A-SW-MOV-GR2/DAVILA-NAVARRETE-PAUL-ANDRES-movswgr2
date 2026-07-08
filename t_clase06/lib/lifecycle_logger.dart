import 'dart:developer' as developer;

/// Imprime en consola los eventos del ciclo de vida usando la misma
/// nomenclatura que Android nativo (onCreate, onStart, onResume, ...)
/// para poder comparar directamente la secuencia de logs entre tecnologías.
class LifecycleLogger {
  const LifecycleLogger(this.tag);

  final String tag;

  void log(String event) {
    developer.log(event, name: tag);
  }
}
