import 'package:flutter/material.dart';

/// Represents an item in the main menu categories.
class MenuItemModel {
  /// The icon representing the category.
  final IconData icon;
  /// The label or name of the category.
  final String label;

  MenuItemModel({required this.icon, required this.label});

  /// Converts the model into a map for storage or transmission.
  Map<String, dynamic> toMap() => {
        'icon': icon,
        'label': label,
      };

  /// Creates a model instance from a map.
  factory MenuItemModel.fromMap(Map<String, dynamic> map) => MenuItemModel(
        icon: map['icon'] as IconData,
        label: map['label'] as String,
      );
}
