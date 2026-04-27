import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import 'service_providers.dart';

/// Notifier class for managing the user's shopping cart.
class CartNotifier extends AsyncNotifier<List<CategoryItemModel>> {
  ///Loads saved data from Firestore.
  @override
  Future<List<CategoryItemModel>> build() async {
    // Watch for authentication state changes
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      return [];
    }

    final db = ref.read(databaseServiceProvider);
    final userData = await db.fetchUserData(user.uid);

    if (userData != null && userData.containsKey('cartItems')) {
      final List<dynamic> jsonList = userData['cartItems'];
      return jsonList.map((e) => CategoryItemModel.fromMap(e as Map<String, dynamic>)).toList();
    }

    // Initial state: empty shopping cart
    return [];
  }

  /// Saves the current state of the shopping cart to Firestore.
  Future<void> _save() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final db = ref.read(databaseServiceProvider);
    final data = state.value!.map((e) => e.toMap()).toList();
    await db.saveField(user.uid, 'cartItems', data);
  }

  /// Adds an item to the shopping cart.
  Future<void> addItem(CategoryItemModel item) async {
    /// spread operator to add item to existing list of shared preference
    final current = state.value ?? [];
    state = AsyncData([...current, item]);
    await _save();
  }

  /// Removes a specific item instance from the shopping cart.
  Future<void> removeItem(CategoryItemModel item) async {
    final current = state.value ?? [];
    final list = [...current];
    final index = list.lastIndexOf(item);
    if (index != -1) {
      list.removeAt(index);
      state = AsyncData(list);
      await _save();
    }
  }

  /// Clears all items from the cart.
  Future<void> clear() async {
    state = const AsyncData([]);
    await _save();
  }
}

/// Provider for managing and accessing the items currently in the cart.
final cartProvider = AsyncNotifierProvider<CartNotifier, List<CategoryItemModel>>(() {
  return CartNotifier();
});

/// Computed provider for calculating the total price of all items in the cart.
final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider).value ?? [];
  return cartItems.fold(0.0, (previousValue, item) {
    // Strip dollar sign, commas, and whitespace then parse
    final rawPrice = item.price.replaceAll('\$', '').replaceAll(',', '').trim();
    /// checks the characters after . and if null turns it into a valid value
    final price = double.tryParse(rawPrice) ?? 0.0;
    return previousValue + price;
  });
});
