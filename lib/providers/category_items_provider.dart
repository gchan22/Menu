import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';

/// Notifier class for managing the items belonging to specific categories.
class CategoryItemsNotifier extends Notifier<Map<String, List<CategoryItemModel>>> {
  @override
  Map<String, List<CategoryItemModel>> build() {
    // Initial state: empty category items mapping
    return {};
  }

  /// Initializes a category with default items if it hasn't been set yet.
  void initializeCategory(String category) {
    if (!state.containsKey(category)) {
      final defaults = [
        CategoryItemModel(name: 'Sample Item 1', price: '\$10.00'),
        CategoryItemModel(name: 'Sample Item 2', price: '\$12.00'),
        CategoryItemModel(name: 'Sample Item 3', price: '\$15.00'),
      ];
      state = {...state, category: defaults};
    }
  }

  /// Sets or updates the list of items for a specific category.
  void setCategoryItems(String category, List<CategoryItemModel> items) {
    state = {...state, category: items};
  }

  /// Adds a new item to an existing or new category.
  void addCategoryItem(String category, CategoryItemModel item) {
    final currentItems = state[category] ?? [];
    state = {...state, category: [...currentItems, item]};
  }

  /// Removes a specific item from a category.
  void removeCategoryItem(String category, CategoryItemModel item) {
    final currentItems = state[category] ?? [];
    state = {
      ...state,
      category: currentItems.where((i) => i != item).toList(),
    };
  }
}

/// Provider to manage the mapping of category names to their respective food items.
final categoryItemsProvider = NotifierProvider<CategoryItemsNotifier, Map<String, List<CategoryItemModel>>>(() {
  return CategoryItemsNotifier();
});
