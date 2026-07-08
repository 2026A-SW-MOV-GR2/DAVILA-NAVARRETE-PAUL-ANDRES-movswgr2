import 'package:flutter/material.dart';

/// Paleta calcada de capturas reales de la app ecuatoriana "Deuna": fondo
/// blanco (billetera "de uso diario", debe verse simple y confiable) con
/// morado como color de marca (botón "Escanear QR", header de perfil, nav
/// seleccionado) y un verde menta como acento secundario para insignias
/// "Nuevo" y elementos de ahorro/beneficio.
abstract class AppColors {
  // Primarios
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF5F4F9); // fondos agrupados suaves

  static const Color primary = Color(0xFF5A2D82); // morado Deuna
  static const Color primaryDark = Color(0xFF3D1F5C);

  // Acento secundario: verde menta (insignias "Nuevo", ahorro).
  static const Color accent = Color(0xFF1FCDA6);
  static const Color accentDark = Color(0xFF17A886);

  // Texto
  static const Color textPrimary = Color(0xFF1B1A22);
  static const Color textSecondary = Color(0xFF6E6C7C);
  static const Color textMuted = Color(0xFF9997A6);

  static const Color divider = Color(0xFFECEAF2);
  static const Color cardBorder = Color(0xFFE8E6EF);

  // Semánticos para movimientos
  static const Color positive = Color(0xFF1FA971);
  static const Color negative = Color(0xFFE5484D);
  static const Color pending = Color(0xFFE0A233);

  static const List<Color> categoryPalette = [
    Color(0xFF5A2D82),
    Color(0xFF1FCDA6),
    Color(0xFFE58A3A),
    Color(0xFF3B82C4),
    Color(0xFFD65C9E),
    Color(0xFF6BBF59),
  ];
}
