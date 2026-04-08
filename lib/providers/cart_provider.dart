import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import 'shared_preferences_provider.dart';
import 'service_providers.dart';

/// Notifier class for managing the user's shopping cart.
class CartNotifier extends Notifier<List<CategoryItemModel>> {
  static const _baseKey = 'cart_items';

  String _getUserKey() {
    final user = ref.read(authStateProvider).value;
    final uid = user?.uid ?? 'guest';
    return '${uid}_$_baseKey';
  }

  ///Loads saved data from shared preferences.
  @override
  List<CategoryItemModel> build() {
    // Watch for authentication state changes
    ref.watch(authStateProvider);

    final prefs = ref.watch(sharedPreferencesProvider);
    final data = prefs.getString(_getUserKey());
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

  /// Saves the current state of the shopping cart to shared preferences.
  void _save() {
    final prefs = ref.read(sharedPreferencesProvider);
    final data = jsonEncode(state.map((e) => e.toMap()).toList());
    prefs.setString(_getUserKey(), data);
  }

  /// Adds an item to the shopping cart.
  void addItem(CategoryItemModel item) {
    /// spread operator to add item to existing list of shared preference
    state = [...state, item];
    _save();
  }

  /// Removes a specific item instance from the shopping cart.
  void removeItem(CategoryItemModel item) {
    final list = [...state];
    final index = list.lastIndexOf(item);
    if (index != -1) {
      list.removeAt(index);
      state = list;
      _save();
    }
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
    // Strip dollar sign, commas, and whitespace then parse
    final rawPrice = item.price.replaceAll('\$', '').replaceAll(',', '').trim();
    /// checks the characters after . and if null turns it into a valid value
    final price = double.tryParse(rawPrice) ?? 0.0;
    return previousValue + price;
  });
});
