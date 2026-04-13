import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/cart_item_row.dart';
import '../providers/cart_provider.dart';
import '../models/category_item.dart';
import '../widgets/cart_summary.dart';
import '../widgets/cart_buttons.dart';
import '../widgets/cart_title.dart';

/// CartScreen displays the list of items the user has added to their virtual cart.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalCost = ref.watch(cartTotalProvider);

    final tax = totalCost * 0.08875;
    final overallTotal = totalCost + tax;

    // Group items by their model to display quantity correctly
    final Map<CategoryItemModel, int> groupedItems = {};
    for (var item in cartItems) {
      groupedItems[item] = (groupedItems[item] ?? 0) + 1;
    }

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
                  const CartTitle(),
                  const SizedBox(height: 20),
                  // Render a row for each item in the cart, grouping duplicates
                  ...groupedItems.entries.map((entry) {
                    return CartItemRow(item: entry.key, quantity: entry.value);
                  }),
                  if (cartItems.isNotEmpty) ...[
                    CartSummary(
                      totalCost: totalCost,
                      tax: tax,
                      overallTotal: overallTotal,
                    ),
                    const SizedBox(height: 20),
                    const CartButtons(),
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
