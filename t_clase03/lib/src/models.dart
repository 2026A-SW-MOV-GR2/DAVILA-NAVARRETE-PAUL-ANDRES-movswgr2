import 'package:flutter/material.dart';

class CrudFormResult {
  const CrudFormResult({required this.item, required this.isEditing});

  final CrudItem item;
  final bool isEditing;
}

class CrudItem {
  const CrudItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.date,
    required this.enabled,
    required this.color,
  });

  final int id;
  final String title;
  final String subtitle;
  final String category;
  final DateTime date;
  final bool enabled;
  final Color color;

  CrudItem copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? category,
    DateTime? date,
    bool? enabled,
    Color? color,
  }) {
    return CrudItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      date: date ?? this.date,
      enabled: enabled ?? this.enabled,
      color: color ?? this.color,
    );
  }
}

String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
