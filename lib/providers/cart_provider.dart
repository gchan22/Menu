import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';

/// Notifier class for managing the user's shopping cart.
class CartNotifier extends Notifier<List<CategoryItemModel>> {
  @override
  List<CategoryItemModel> build() {
    // Initial state: empty shopping cart
    return [];
  }

  /// Adds an item to the shopping cart.
  void addItem(CategoryItemModel item) {
    state = [...state, item];
  }

  /// Removes a specific item instance from the shopping cart.
  void removeItem(CategoryItemModel item) {
    state = state.where((i) => i != item).toList();
  }

  /// Clears all items from the cart.
  void clear() {
    state = [];
  }
}

/// Provider for managing and accessing the items currently in the cart.
final cartProvider = NotifierProvider<CartNotifier, List<CategoryItemModel>>(() {
  return CartNotifier();
});

/// Computed provider for calculating the total price of all items in the cart.
final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0.0, (previousValue, item) {
    final price = double.tryParse(item.price) ?? 0.0;
    return previousValue + price;
  });
});
