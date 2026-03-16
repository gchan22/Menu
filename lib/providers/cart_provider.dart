import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import 'shared_preferences_provider.dart';

/// Notifier class for managing the user's shopping cart.
class CartNotifier extends Notifier<List<CategoryItemModel>> {
  static const _key = 'cart_items';

  @override
  List<CategoryItemModel> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final data = prefs.getString(_key);
    if (data != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((e) => CategoryItemModel.fromMap(e)).toList();
      } catch (e) {
        // Fallback
      }
    }
    // Initial state: empty shopping cart
    return [];
  }

  void _save() {
    final prefs = ref.read(sharedPreferencesProvider);
    final data = jsonEncode(state.map((e) => e.toMap()).toList());
    prefs.setString(_key, data);
  }

  /// Adds an item to the shopping cart.
  void addItem(CategoryItemModel item) {
    state = [...state, item];
    _save();
  }

  /// Removes a specific item instance from the shopping cart.
  void removeItem(CategoryItemModel item) {
    state = state.where((i) => i != item).toList();
    _save();
  }

  /// Clears all items from the cart.
  void clear() {
    state = [];
    _save();
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
    // Strip dollar sign and parse
    final rawPrice = item.price.replaceAll('\$', '').trim();
    final price = double.tryParse(rawPrice) ?? 0.0;
    return previousValue + price;
  });
});
