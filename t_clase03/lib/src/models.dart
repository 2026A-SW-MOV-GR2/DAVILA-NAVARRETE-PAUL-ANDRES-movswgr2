import 'package:flutter/material.dart';

class PostModel {
  const PostModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  final int userId;
  final int id;
  final String title;
  final String body;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: json['userId'] as int? ?? 1,
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  PostModel copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) {
    return PostModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}

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

  factory CrudItem.fromMap(Map<String, dynamic> map) {
    return CrudItem(
      id: map['id'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      category: map['category'] as String? ?? 'Nuevo',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int? ?? DateTime.now().millisecondsSinceEpoch),
      enabled: map['enabled'] as bool? ?? true,
      color: Color(map['color'] as int? ?? 0xFF6D28D9),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'date': date.millisecondsSinceEpoch,
      'enabled': enabled,
      'color': color.value,
    };
  }

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

List<CrudItem> defaultCrudItems() {
  return [
    CrudItem(
      id: 1,
      title: 'Watchmen',
      subtitle: 'Alan Moore & Dave Gibbons',
      category: 'Nuevo',
      date: DateTime(2026, 1, 12),
      enabled: true,
      color: const Color(0xFF6D28D9),
    ),
    CrudItem(
      id: 2,
      title: 'The Sandman Vol. 1',
      subtitle: 'Neil Gaiman',
      category: 'Usado',
      date: DateTime(2026, 1, 18),
      enabled: true,
      color: const Color(0xFF7C3AED),
    ),
    CrudItem(
      id: 3,
      title: 'V for Vendetta',
      subtitle: 'Alan Moore & David Lloyd',
      category: 'Nuevo',
      date: DateTime(2026, 2, 2),
      enabled: true,
      color: const Color(0xFFEAB308),
    ),
  ];
}
