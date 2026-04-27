import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import 'service_providers.dart';

/// Notifier class for managing the main menu categories.
class MenuNotifier extends AsyncNotifier<List<MenuItemModel>> {
  /// load saved menu categories from Firestore
  @override
  Future<List<MenuItemModel>> build() async {
    // Watch for authentication state changes
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return [];
    }

    final db = ref.read(databaseServiceProvider);
    final userData = await db.fetchUserData(user.uid);

    if (userData != null && userData.containsKey('menuItems')) {
      final List<dynamic> jsonList = userData['menuItems'];
      return jsonList.map((e) => MenuItemModel.fromMap(e as Map<String, dynamic>)).toList();
    }

    // Default categories for the application
    return [];
  }

  /// Save current state to Firestore
  Future<void> _save() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final db = ref.read(databaseServiceProvider);
    final data = state.value!.map((e) => e.toMap()).toList();
    await db.saveField(user.uid, 'menuItems', data);
  }

  /// Adds a new category to the menu.
  Future<void> addMenuItem(MenuItemModel item) async {
    final current = state.value ?? [];
    state = AsyncData([...current, item]);
    await _save();
  }

  /// Updates an existing menu item at a specific index.
  Future<void> updateMenuItem(int index, MenuItemModel newItem) async {
    final current = state.value ?? [];
    final newList = List<MenuItemModel>.from(current)..[index] = newItem;
    state = AsyncData(newList);
    await _save();
  }

  /// Removes a specific category from the menu.
  Future<void> removeMenuItem(MenuItemModel item) async {
    final current = state.value ?? [];
    state = AsyncData(current.where((i) => i != item).toList());
    await _save();
  }

  /// Resets the menu items list to its initial empty state.
  Future<void> reset() async {
    state = const AsyncData([]);
    await _save();
  }
}

/// Provider for managing the list of top-level menu categories.
final menuProvider = AsyncNotifierProvider<MenuNotifier, List<MenuItemModel>>(() {
  return MenuNotifier();
});
