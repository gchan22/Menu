import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../models/cart_state.dart';

/// CartScreen displays the list of items the user has added to their virtual cart.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a UI row for an item in the cart, including a remove button.
  Widget _buildCartRow(String itemName) {
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
          Row(
            children: [
              const Icon(Icons.shopping_cart, size: 24, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Text(itemName, style: const TextStyle(fontSize: 18)),
            ],
          ),
          // Button to remove the item from the cart state
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () {
              setState(() {
                CartState.removeItem(itemName);
              });
            },
          ),
        ],
      ),
    );
  }
}
