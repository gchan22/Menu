import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import 'description.dart';
import 'cart.dart';
import '../cart_state.dart';

class ItemsScreen extends StatefulWidget {
  final String category;

  const ItemsScreen({super.key, required this.category});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Items'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
            child: Column(
              children: [
                _buildItemRow(context, 'Sample Item 1', '\$10.00'),
                const SizedBox(height: 10),
                _buildItemRow(context, 'Sample Item 2', '\$12.00'),
                const SizedBox(height: 10),
                _buildItemRow(context, 'Sample Item 3', '\$15.00'),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Stack(
              children: [
                FloatingActionButton(
                  heroTag: 'cartFAB',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    ).then((_) {
                      // Rebuild when returning from cart screen in case items were removed
                      setState(() {});
                    });
                  },
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(Icons.shopping_cart, color: Colors.white),
                ),
                if (CartState.items.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '${CartState.items.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add item logic here
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, String name, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Text(price, style: const TextStyle(fontSize: 18, color: Colors.green)),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blueAccent),
            onPressed: () {
              setState(() {
                CartState.addItem(name);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name added to cart!'), duration: const Duration(seconds: 1)),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DescriptionScreen(itemName: name),
                ),
              );
            },
            child: const Text('More Information'),
          ),
        ],
      ),
    );
  }
}
