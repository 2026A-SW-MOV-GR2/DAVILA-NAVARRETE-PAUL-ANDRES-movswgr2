import 'package:flutter/material.dart';

enum TransactionType { sent, received, payment, recharge }

class WalletTransaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final IconData icon;
  final Color accentColor;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.type,
    required this.icon,
    required this.accentColor,
  });

  bool get isCredit => type == TransactionType.received;
}
