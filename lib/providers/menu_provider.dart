import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import 'shared_preferences_provider.dart';
import 'service_providers.dart';

/// Notifier class for managing the main menu categories.
class MenuNotifier extends Notifier<List<MenuItemModel>> {
  static const _baseKey = 'menu_items';

  String _getUserKey() {
    final user = ref.read(authStateProvider).value;
    final uid = user?.uid ?? 'guest';
    return '${uid}_$_baseKey';
  }

  /// load saved preferences
  @override
  List<MenuItemModel> build() {
    // Watch for authentication state changes
    ref.watch(authStateProvider);

    final prefs = ref.watch(sharedPreferencesProvider);
    final data = prefs.getString(_getUserKey());
    if (data != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((e) => MenuItemModel.fromMap(e)).toList();
      } catch (e) {
        // Fallback to default
      }
    }

    // Default categories for the application
    return [];
  }

  /// Save current state to preferences
  void _save() {
    final prefs = ref.read(sharedPreferencesProvider);
    final data = jsonEncode(state.map((e) => e.toMap()).toList());
    prefs.setString(_getUserKey(), data);
  }

  /// Adds a new category to the menu.
  void addMenuItem(MenuItemModel item) {
    state = [...state, item];
    _save();
  }

  /// Updates an existing menu item at a specific index.
  void updateMenuItem(int index, MenuItemModel newItem) {
    final newList = List<MenuItemModel>.from(state)..[index] = newItem;
    state = newList;
    _save();
  }

  /// Removes a specific category from the menu.
  void removeMenuItem(MenuItemModel item) {
    state = state.where((i) => i != item).toList();
    _save();
  }

  /// Resets the menu items list to its initial empty state.
  void reset() {
    state = [];
    _save();
  }
}

/// Provider for managing the list of top-level menu categories.
final menuProvider = NotifierProvider<MenuNotifier, List<MenuItemModel>>(() {
  return MenuNotifier();
});
