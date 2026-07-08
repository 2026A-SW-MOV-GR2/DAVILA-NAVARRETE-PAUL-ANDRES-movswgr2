import 'package:flutter/material.dart';

class WalletAccount {
  final String label;
  final String maskedNumber;
  final double balance;
  final Color color;
  final IconData icon;

  const WalletAccount({
    required this.label,
    required this.maskedNumber,
    required this.balance,
    required this.color,
    required this.icon,
  });
}
