import 'package:flutter/material.dart';

import 'counter_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T. Clase 06 - Ciclo de vida',
      // Habilita la restauración de estado para toda la app; cada State
      // que quiera participar debe declarar su propio restorationId.
      restorationScopeId: 'app',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const CounterPage(),
    );
  }
}
