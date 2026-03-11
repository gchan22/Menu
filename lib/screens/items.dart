import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'description.dart';
import 'cart.dart';
import 'finalized_items.dart';
import '../models/cart_state.dart';
import '../models/category_item.dart';

/// ItemsScreen displays and manages a list of food items within a specific category.
class ItemsScreen extends StatefulWidget {
  final String category;

  const ItemsScreen({super.key, required this.category});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  late List<CategoryItemModel> _items;

  @override
  void initState() {
    super.initState();
    // Load items for this category from global state, or provide samples if empty
    final storedItems = CartState.itemsByCategory[widget.category];
    if (storedItems != null) {
      _items = List.from(storedItems);
    } else {
      _items = [
        CategoryItemModel(name: 'Sample Item 1', price: '\$10.00'),
        CategoryItemModel(name: 'Sample Item 2', price: '\$12.00'),
        CategoryItemModel(name: 'Sample Item 3', price: '\$15.00'),
      ];
      // Save these samples back to CartState immediately so they persist
      CartState.updateCategoryItems(widget.category, _items);
    }
  }

  /// Saves the current list of items for this category to the global state.
  void _saveData() {
    CartState.updateCategoryItems(widget.category, _items);
  }

  @override
  Widget build(BuildContext context) {
    // Floating action button for the shopping cart with a badge showing item count
    final cartFAB = Stack(
      children: [
        FloatingActionButton(
          heroTag: 'cartFAB',
          onPressed: () {
            _saveData();
            // Navigate to the shopping cart screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ).then((_) {
              // Refresh count when returning from cart
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

    // Button to exit editing and view the finalized items list
    final exitButton = Center(
      child: CustomButton(
        label: 'Exit',
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

  /// Displays a dialog to add a new food item with a name and price.
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
              CustomTextField(
                controller: nameController,
                label: 'Item Name',
                filled: false,
              ),
              CustomTextField(
                controller: priceController,
                label: 'Price (e.g., \$10.00)',
                filled: false,
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
                    _items.add(CategoryItemModel(
                      name: nameController.text,
                      price: priceController.text,
                    ));
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

  /// Builds a UI row for an individual food item.
  Widget _buildItemRow(CategoryItemModel item, int index) {
    final name = item.name;
    final price = item.price;

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
          // Add to cart button
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blueAccent),
            onPressed: () {
              setState(() {
                CartState.addItem(item);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name added to cart!'), duration: const Duration(seconds: 1)),
              );
            },
          ),
          // Button to view/edit item descriptions
          CustomButton(
            label: 'More Information',
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
          ),
          // Button to remove item from list
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
