import 'package:flutter/material.dart';

import '../models/quick_action.dart';
import '../theme/app_colors.dart';
import 'press_scale.dart';

/// Tile cuadrado blanco con ícono a color, igual al grid de accesos
/// directos de la app real (Transferir, Recargar, Pagar servicios, etc.).
class QuickActionButton extends StatelessWidget {
  final QuickAction action;
  final VoidCallback? onTap;

  const QuickActionButton({super.key, required this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap ?? () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Icon(action.icon, color: action.color, size: 26),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 68,
            child: Text(
              action.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }
}
