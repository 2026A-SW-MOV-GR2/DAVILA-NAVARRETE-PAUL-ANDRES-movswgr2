import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/press_scale.dart';
import 'benefits_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'qr_scan_screen.dart';
import 'wallet_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    BenefitsScreen(),
    MapScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  static const _tabs = [
    (Icons.home_rounded, 'Inicio', null),
    (Icons.card_giftcard_rounded, 'Beneficios', 'Nuevo'),
    (Icons.location_on_rounded, 'Mapa', null),
    (Icons.account_balance_wallet_rounded, 'Billetera', 'Nuevo'),
    (Icons.person_rounded, 'Tú', null),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: _screens[_index],
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_index == 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                  child: PressScale(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const QrScanScreen()),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text('Escanear QR',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    for (var i = 0; i < _tabs.length; i++)
                      Expanded(
                        child: _NavItem(
                          icon: _tabs[i].$1,
                          label: _tabs[i].$2,
                          badge: _tabs[i].$3,
                          selected: _index == i,
                          onTap: () => setState(() => _index = i),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.badge,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textMuted;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedScale(
                scale: selected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: Icon(icon, color: color, size: 22),
              ),
              if (badge != null)
                Positioned(
                  right: -14,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(6)),
                    child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w600),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
