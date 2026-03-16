import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/cart_item_row.dart';
import '../widgets/custom_button.dart';
import '../models/category_item.dart';
import '../providers/cart_provider.dart';

/// CartScreen displays the list of items the user has added to their virtual cart.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalCost = ref.watch(cartTotalProvider);

    // A styled header box for the cart screen
    final cartTitle = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Cart',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    // Total cost row displayed at the bottom of the list
    final totalRow = Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Cost:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${totalCost.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  cartTitle,
                  const SizedBox(height: 20),
                  // Render a row for each item in the cart
                  ...cartItems.map((item) {
                    return CartItemRow(item: item);
                  }),
                  if (cartItems.isNotEmpty) ...[
                    totalRow,
                    const SizedBox(height: 20),
                    CustomButton(
                      label: 'Clear Cart',
                      onPressed: () {
                        ref.read(cartProvider.notifier).clear();
                      },
                    ),
                  ],
                  if (cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text('Your cart is empty', style: TextStyle(fontSize: 18)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
