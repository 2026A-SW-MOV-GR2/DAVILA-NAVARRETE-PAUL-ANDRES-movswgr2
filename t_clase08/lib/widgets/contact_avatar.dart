import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../theme/app_colors.dart';
import 'press_scale.dart';

/// Item de la lista horizontal/vertical de contactos para envío rápido.
class ContactAvatar extends StatelessWidget {
  final WalletContact contact;
  final VoidCallback? onTap;

  const ContactAvatar({super.key, required this.contact, this.onTap});

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap ?? () {},
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: contact.color.withValues(alpha: 0.25),
              child: Text(
                contact.initials,
                style: TextStyle(
                  color: contact.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              contact.name.split(' ').first,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
