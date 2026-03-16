import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import 'shared_preferences_provider.dart';
import 'service_providers.dart';

/// Notifier class for managing the items belonging to specific categories.
class CategoryItemsNotifier extends Notifier<Map<String, List<CategoryItemModel>>> {
  static const _baseKey = 'category_items';

  String _getUserKey() {
    final user = ref.read(authStateProvider).value;
    final uid = user?.uid ?? 'guest';
    return '${uid}_$_baseKey';
  }

  /// loads saved preference
  @override
  Map<String, List<CategoryItemModel>> build() {
    // Watch for authentication state changes
    ref.watch(authStateProvider);

    final prefs = ref.watch(sharedPreferencesProvider);
    final data = prefs.getString(_getUserKey());
    if (data != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(data);
        return jsonMap.map((key, value) {
          final List<dynamic> list = value;
          return MapEntry(key, list.map((e) => CategoryItemModel.fromMap(e)).toList());
        });
      } catch (e) {
        // Fallback
      }
    }
    // Initial state: empty category items mapping
    return {};
  }

  /// Saves the current state of the category items to shared preferences.
  void _save() {
    final prefs = ref.read(sharedPreferencesProvider);
    final mapToSave = state.map((key, value) {
      return MapEntry(key, value.map((e) => e.toMap()).toList());
    });
    prefs.setString(_getUserKey(), jsonEncode(mapToSave));
  }

  /// Initializes a category with an empty list if it hasn't been set yet.
  void initializeCategory(String category) {
    if (!state.containsKey(category)) {
      state = {...state, category: []};
      _save();
    }
  }

  /// Sets or updates the list of items for a specific category.
  void setCategoryItems(String category, List<CategoryItemModel> items) {
    state = {...state, category: items};
    _save();
  }

  /// Adds a new item to an existing or new category.
  void addCategoryItem(String category, CategoryItemModel item) {
    final currentItems = state[category] ?? [];
    state = {...state, category: [...currentItems, item]};
    _save();
  }

  /// Removes a specific item from a category.
  void removeCategoryItem(String category, CategoryItemModel item) {
    final currentItems = state[category] ?? [];
    state = {
      ...state,
      category: currentItems.where((i) => i != item).toList(),
    };
    _save();
  }

  /// Resets the category items mapping to its initial empty state.
  void reset() {
    state = {};
    _save();
  }
}

/// Provider to manage the mapping of category names to their respective food items.
final categoryItemsProvider = NotifierProvider<CategoryItemsNotifier, Map<String, List<CategoryItemModel>>>(() {
  return CategoryItemsNotifier();
});
