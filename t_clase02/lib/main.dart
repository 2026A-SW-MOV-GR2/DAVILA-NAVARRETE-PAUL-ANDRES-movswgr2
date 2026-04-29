import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('resources_channel');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResourcesHome(),
    );
  }
}

class ResourcesHome extends StatefulWidget {
  const ResourcesHome({super.key});

  @override
  State<ResourcesHome> createState() => _ResourcesHomeState();
}

class _ResourcesHomeState extends State<ResourcesHome> {
  String text = 'Cargando...';
  Color textColor = Colors.black;
  Color bgColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _installMethodHandler();
    _loadResources();
  }

  void _installMethodHandler() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'resourcesChanged') {
        await _loadResources();
      }
    });
  }

  Future<void> _loadResources() async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>('getResources');
      if (!mounted || result == null) {
        return;
      }

      final newText = result['text'] as String? ?? '';
      final newTextColor = _colorFromHex(result['textColor'] as String? ?? '#000000');
      final newBgColor = _colorFromHex(result['bgColor'] as String? ?? '#FFFFFF');

      setState(() {
        text = newText;
        textColor = newTextColor;
        bgColor = newBgColor;
      });
    } on PlatformException catch (error) {
      debugPrint('Error leyendo recursos nativos: $error');
    } catch (error) {
      debugPrint('Canal no disponible o error inesperado: $error');
    }
  }

  Color _colorFromHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    final normalized = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return Color(int.parse(normalized, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SizedBox.expand(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
