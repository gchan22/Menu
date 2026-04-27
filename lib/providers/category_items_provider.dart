import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import 'service_providers.dart';

/// Notifier class for managing the items belonging to specific categories.
class CategoryItemsNotifier extends AsyncNotifier<Map<String, List<CategoryItemModel>>> {
  /// loads saved items from Firestore
  @override
  Future<Map<String, List<CategoryItemModel>>> build() async {
    // Watch for authentication state changes
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return {};
    }

    final db = ref.read(databaseServiceProvider);
    final userData = await db.fetchUserData(user.uid);

    if (userData != null && userData.containsKey('categoryItems')) {
      final Map<String, dynamic> jsonMap = userData['categoryItems'];
      return jsonMap.map((key, value) {
        final List<dynamic> list = value;
        return MapEntry(key, list.map((e) => CategoryItemModel.fromMap(e as Map<String, dynamic>)).toList());
      });
    }

    // Initial state: empty category items mapping
    return {};
  }

  /// Saves the current state of the category items to Firestore.
  Future<void> _save() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final db = ref.read(databaseServiceProvider);
    final mapToSave = state.value!.map((key, value) {
      return MapEntry(key, value.map((e) => e.toMap()).toList());
    });
    await db.saveField(user.uid, 'categoryItems', mapToSave);
  }

  /// Initializes a category with an empty list if it hasn't been set yet.
  Future<void> initializeCategory(String category) async {
    final current = state.value ?? {};
    if (!current.containsKey(category)) {
      state = AsyncData({...current, category: []});
      await _save();
    }
  }

  /// Sets or updates the list of items for a specific category.
  Future<void> setCategoryItems(String category, List<CategoryItemModel> items) async {
    final current = state.value ?? {};
    state = AsyncData({...current, category: items});
    await _save();
  }

  /// Adds a new item to an existing or new category.
  Future<void> addCategoryItem(String category, CategoryItemModel item) async {
    final current = state.value ?? {};
    final currentItems = current[category] ?? [];
    state = AsyncData({...current, category: [...currentItems, item]});
    await _save();
  }

  /// Removes a specific item from a category.
  Future<void> removeCategoryItem(String category, CategoryItemModel item) async {
    final current = state.value ?? {};
    final currentItems = current[category] ?? [];
    state = AsyncData({
      ...current,
      category: currentItems.where((i) => i != item).toList(),
    });
    await _save();
  }

  /// Resets the category items mapping to its initial empty state.
  Future<void> reset() async {
    state = const AsyncData({});
    await _save();
  }
}

/// Provider to manage the mapping of category names to their respective food items.
final categoryItemsProvider = AsyncNotifierProvider<CategoryItemsNotifier, Map<String, List<CategoryItemModel>>>(() {
  return CategoryItemsNotifier();
});
