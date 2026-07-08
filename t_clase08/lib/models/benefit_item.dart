import 'package:flutter/material.dart';

class BenefitItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool locked;

  const BenefitItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.locked = false,
  });
}
