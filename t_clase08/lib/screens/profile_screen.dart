import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _options = [
    (Icons.person_outline_rounded, 'Información personal'),
    (Icons.face_retouching_natural_rounded, 'Apariencia'),
    (Icons.tune_rounded, 'Configuración de límites'),
    (Icons.wifi_off_rounded, 'Pagos sin internet'),
    (Icons.lock_outline_rounded, 'Cambio de clave'),
    (Icons.storefront_outlined, 'Mi negocio'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: Color(0xFFBFEFDD),
                  child: Text('PD', style: TextStyle(color: Color(0xFF17664F), fontWeight: FontWeight.w700, fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Paul Dávila',
                        style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Color(0xFFF4A25C), shape: BoxShape.circle),
                      child: const Text('d!',
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Última sesión: 24 mar. 2026 | 04:33',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const Text('Versión 5.2.87.1367', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _options.length,
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 20, endIndent: 20),
              itemBuilder: (context, index) {
                final option = _options[index];
                return ListTile(
                  leading: Icon(option.$1, color: AppColors.textSecondary),
                  title: Text(option.$2, style: const TextStyle(color: AppColors.textPrimary)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
