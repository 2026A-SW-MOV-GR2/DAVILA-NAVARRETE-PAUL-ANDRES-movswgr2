import 'package:flutter/material.dart';

import '../models/business.dart';
import '../theme/app_colors.dart';

/// Mapa "de mentira": dibuja calles abstractas con [CustomPainter] y ubica
/// pines de negocios en coordenadas relativas. Evita depender de un SDK de
/// mapas real (API key, tiles de red) que no aporta al objetivo del taller
/// (fidelidad de UI, no integración de mapas).
class FakeMap extends StatelessWidget {
  final List<Business> businesses;

  const FakeMap({super.key, required this.businesses});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _StreetsPainter())),
              for (final b in businesses)
                Positioned(
                  left: b.dx * constraints.maxWidth - 14,
                  top: b.dy * constraints.maxHeight - 28,
                  child: Column(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary, size: 28),
                      Text(b.name,
                          style: const TextStyle(fontSize: 9, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StreetsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFEFECF6);
    canvas.drawRect(Offset.zero & size, bg);

    final street = Paint()
      ..color = Colors.white
      ..strokeWidth = 10;
    for (var i = 1; i < 5; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), street);
    }
    for (var i = 1; i < 4; i++) {
      final x = size.width * i / 4;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), street);
    }

    final park = Paint()..color = const Color(0xFFDCEFE2);
    canvas.drawOval(Rect.fromLTWH(size.width * 0.55, size.height * 0.05, size.width * 0.35, size.height * 0.25), park);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
