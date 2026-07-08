import 'package:flutter/material.dart';

class WalletContact {
  final String name;
  final String phone;
  final Color color;
  final bool isFavorite;

  const WalletContact({
    required this.name,
    required this.phone,
    required this.color,
    this.isFavorite = false,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}
