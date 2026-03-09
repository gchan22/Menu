import 'package:flutter/material.dart';

class MenuItemModel {
  final IconData icon;
  final String label;

  MenuItemModel({required this.icon, required this.label});

  Map<String, dynamic> toMap() => {
        'icon': icon,
        'label': label,
      };

  factory MenuItemModel.fromMap(Map<String, dynamic> map) => MenuItemModel(
        icon: map['icon'] as IconData,
        label: map['label'] as String,
      );
}
