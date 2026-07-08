import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/fade_slide_in.dart';
import 'movements_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billetera'),
        actions: [
          IconButton(
            onPressed: () => setState(() => _visible = !_visible),
            icon: Icon(_visible ? Icons.visibility_rounded : Icons.visibility_off_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const Text('Cuentas', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (var i = 0; i < MockData.walletAccounts.length; i++)
            FadeSlideIn(
              index: i,
              child: Builder(builder: (context) {
                final account = MockData.walletAccounts[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: account.color.withValues(alpha: 0.15),
                    child: Icon(account.icon, color: account.color),
                  ),
                  title: Text('${account.label} ${account.maskedNumber}',
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text(
                    _visible ? '\$${account.balance.toStringAsFixed(2).replaceFirst('.', ',')}' : '••••',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MovementsScreen()),
                  ),
                );
              }),
            ),
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Text('No veo todas mis cuentas',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                  SizedBox(width: 6),
                  Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Cuentas de mis hijos/as',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Crea una cuenta nueva para un menor de edad',
                          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13.5)),
                      const SizedBox(height: 4),
                      const Text('Si tienes hijos entre 12 y 17 años ya pueden usar Deuna',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('Crear ahora ›',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.headphones_rounded, color: AppColors.accent, size: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
