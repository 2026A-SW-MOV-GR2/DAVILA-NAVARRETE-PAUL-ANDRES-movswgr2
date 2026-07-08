import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../theme/app_colors.dart';

class ContactListTile extends StatelessWidget {
  final WalletContact contact;
  final VoidCallback? onTap;

  const ContactListTile({super.key, required this.contact, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: contact.color.withValues(alpha: 0.25),
        child: Text(
          contact.initials,
          style: TextStyle(color: contact.color, fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(
        contact.name,
        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        contact.phone,
        style: const TextStyle(color: AppColors.textMuted),
      ),
      trailing: contact.isFavorite
          ? const Icon(Icons.star_rounded, color: AppColors.pending)
          : const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
    );
  }
}
