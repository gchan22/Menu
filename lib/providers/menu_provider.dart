import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';

/// Notifier class for managing the main menu categories.
class MenuNotifier extends Notifier<List<MenuItemModel>> {
  @override
  List<MenuItemModel> build() {
    // Default categories for the application
    return [
      MenuItemModel(icon: Icons.restaurant, label: 'Chicken'),
      MenuItemModel(icon: Icons.restaurant, label: 'Beef'),
      MenuItemModel(icon: Icons.restaurant, label: 'Pork'),
      MenuItemModel(icon: Icons.local_drink, label: 'Soda'),
    ];
  }

  /// Adds a new category to the menu.
  void addMenuItem(MenuItemModel item) {
    state = [...state, item];
  }

  /// Updates an existing menu item at a specific index.
  void updateMenuItem(int index, MenuItemModel newItem) {
    final newList = List<MenuItemModel>.from(state)..[index] = newItem;
    state = newList;
  }

  /// Removes a specific category from the menu.
  void removeMenuItem(MenuItemModel item) {
    state = state.where((i) => i != item).toList();
  }
}

/// Provider for managing the list of top-level menu categories.
final menuProvider = NotifierProvider<MenuNotifier, List<MenuItemModel>>(() {
  return MenuNotifier();
});
