import 'package:flutter/material.dart';

import 'lifecycle_logger.dart';

/// Pantalla del contador para el taller de ciclo de vida y persistencia.
///
/// Combina dos mecanismos que en Android nativo están separados:
/// - [WidgetsBindingObserver]: notifica los cambios de [AppLifecycleState]
///   (resumed / inactive / paused / hidden / detached), el equivalente a
///   onResume/onPause/onStop/onDestroy.
/// - [RestorationMixin]: es el reemplazo de onSaveInstanceState /
///   onRestoreInstanceState. Guarda el valor del contador para que
///   sobreviva a la destrucción del proceso (no a un simple rebuild).
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage>
    with WidgetsBindingObserver, RestorationMixin {
  static const _logger = LifecycleLogger('LIFECYCLE');

  static const _startValue = 0;

  final RestorableInt _count = RestorableInt(_startValue);
  AppLifecycleState? _previousState;

  @override
  String? get restorationId => 'counter_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_count, 'count');
    if (!initialRestore) {
      // Solo se ejecuta cuando el proceso fue matado y Flutter recuperó
      // el valor guardado: el equivalente a onRestoreInstanceState().
      _logger.log('onRestoreInstanceState() -> count = ${_count.value}');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // En Flutter no existe un evento nativo de "creación de actividad":
    // initState() ocurre una sola vez por instancia de State, igual que
    // onCreate() en Android.
    _logger.log('onCreate()');
    _logger.log('onStart()');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_previousState == null) {
      // Primer frame visible en pantalla: equivalente a onResume().
      _logger.log('onResume()');
      _previousState = AppLifecycleState.resumed;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        final wasStopped = _previousState == AppLifecycleState.paused ||
            _previousState == AppLifecycleState.hidden;
        if (wasStopped) {
          _logger.log('onRestart()');
          _logger.log('onStart()');
        }
        _logger.log('onResume()');
      case AppLifecycleState.inactive:
        _logger.log('onPause()');
      case AppLifecycleState.hidden:
        _logger.log('onStop()  [hidden]');
      case AppLifecycleState.paused:
        _logger.log('onStop()');
      case AppLifecycleState.detached:
        _logger.log('onDestroy()  [motor Flutter desacoplado de la vista]');
    }
    _previousState = state;
  }

  @override
  void dispose() {
    _logger.log('onDestroy()');
    WidgetsBinding.instance.removeObserver(this);
    _count.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() => _count.value++);
  }

  void _reset() {
    setState(() => _count.value = _startValue);
  }

  @override
  Widget build(BuildContext context) {
    // Se ejecuta en cada rebuild, incluyendo la rotación de pantalla. En
    // Flutter/Android la rotación NO destruye el State (ver configChanges
    // en AndroidManifest.xml), así que _count conserva su valor sin
    // necesidad de restauración.
    return Scaffold(
      appBar: AppBar(title: const Text('Taller: Ciclo de vida (Flutter)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Valor del contador:'),
            Text(
              '${_count.value}',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  label: const Text('Sumar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reiniciar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
