import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../models/cart_state.dart';
import '../models/category_item.dart';

/// CartScreen displays the list of items the user has added to their virtual cart.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// Calculates the total cost of all items in the cart.
  double _calculateTotal() {
    double total = 0.0;
    for (var item in CartState.items) {
      // Remove currency symbols and parse the price string
      String priceStr = item.price.replaceAll(RegExp(r'[^\d.]'), '');
      total += double.tryParse(priceStr) ?? 0.0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
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
            '\$${_calculateTotal().toStringAsFixed(2)}',
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
                  ...CartState.items.map((item) {
                    return _buildCartRow(item);
                  }).toList(),
                  if (CartState.items.isNotEmpty) totalRow,
                  if (CartState.items.isEmpty)
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

  /// Builds a UI row for an item in the cart, including its price and a remove button.
  Widget _buildCartRow(CategoryItemModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, size: 24, color: Colors.blueAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.price,
            style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          // Button to remove the item from the cart state
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () {
              setState(() {
                CartState.removeItem(item);
              });
            },
          ),
        ],
      ),
    );
  }
}
