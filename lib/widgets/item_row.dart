import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import '../providers/cart_provider.dart';
import '../providers/category_items_provider.dart';
import '../screens/description.dart';
import 'custom_button.dart';

/// A UI row for an individual food item in the items editing screen.
class ItemRow extends ConsumerWidget {
  final CategoryItemModel item;
  final String category;

  const ItemRow({
    super.key,
    required this.item,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ref.read(cartProvider.notifier).addItem(item);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name added to cart!'), duration: const Duration(seconds: 1)),
              );
            },
          ),
          // Button to view/edit item descriptions
          CustomButton(
            label: 'More Information',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DescriptionScreen(
                    itemName: name,
                    category: category,
                  ),
                ),
              );
            },
          ),
          // Button to remove item from list
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () {
              ref.read(categoryItemsProvider.notifier).removeCategoryItem(category, item);
            },
          ),
        ],
      ),
    );
  }
}
