import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import 'description.dart';
import 'cart.dart';
import 'finalized_items.dart';
import '../cart_state.dart';

class ItemsScreen extends StatefulWidget {
  final String category;

  const ItemsScreen({super.key, required this.category});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  late List<Map<String, String>> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(CartState.itemsByCategory[widget.category] ?? [
      {'name': 'Sample Item 1', 'price': '\$10.00'},
      {'name': 'Sample Item 2', 'price': '\$12.00'},
      {'name': 'Sample Item 3', 'price': '\$15.00'},
    ]);
  }

  void _saveData() {
    CartState.updateCategoryItems(widget.category, _items);
  }

  @override
  Widget build(BuildContext context) {
    final cartFAB = Stack(
      children: [
        FloatingActionButton(
          heroTag: 'cartFAB',
          onPressed: () {
            _saveData();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ).then((_) {
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
    );

    final exitButton = Center(
      child: ElevatedButton(
        onPressed: () {
          _saveData();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinalizedItemsScreen(
                category: widget.category,
                items: _items,
              ),
            ),
          );
        },
        child: const Text('Exit'),
      ),
    );

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
            padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 80.0),
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _items[index];
                return _buildItemRow(item, index);
              },
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: cartFAB,
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: exitButton,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price (e.g., \$10.00)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  setState(() {
                    _items.add({
                      'name': nameController.text,
                      'price': priceController.text,
                    });
                  });
                  _saveData();
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildItemRow(Map<String, String> item, int index) {
    final name = item['name']!;
    final price = item['price']!;

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
              _saveData();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DescriptionScreen(
                    itemName: name,
                    category: widget.category,
                  ),
                ),
              );
            },
            child: const Text('More Information'),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () {
              setState(() {
                _items.removeAt(index);
              });
              _saveData();
            },
          ),
        ],
      ),
    );
  }
}
