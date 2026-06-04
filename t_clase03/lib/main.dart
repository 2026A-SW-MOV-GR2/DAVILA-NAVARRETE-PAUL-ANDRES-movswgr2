import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'src/data/database_provider.dart';
import 'src/providers/crud_controller.dart';
import 'src/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProxyProvider<DatabaseProvider, CrudController>(
          create: (context) => CrudController(context.read<DatabaseProvider>()),
          update: (context, databaseProvider, controller) {
            return controller ?? CrudController(databaseProvider);
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cómics Store',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF6D28D9),
          scaffoldBackgroundColor: const Color(0xFFFAF5FF),
        ),
        home: const CrudHomePage(),
      ),
    );
  }
}

