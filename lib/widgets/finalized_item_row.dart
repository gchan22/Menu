import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import '../providers/cart_provider.dart';
import '../screens/finalized_description.dart';
import 'custom_button.dart';

/// A UI row for a single item in the finalized items list.
class FinalizedItemRow extends ConsumerWidget {
  final CategoryItemModel item;
  final String category;
  final List<String> descriptionRows;

  const FinalizedItemRow({
    super.key,
    required this.item,
    required this.category,
    required this.descriptionRows,
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
          // Customer can still add items to cart from the finalized view
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blueAccent),
            onPressed: () {
              ref.read(cartProvider.notifier).addItem(item);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name added to cart!'), duration: const Duration(seconds: 1)),
              );
            },
          ),
          // View detailed item description in finalized mode
          CustomButton(
            label: 'More Information',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FinalizedDescriptionScreen(
                    itemName: name,
                    descriptionRows: descriptionRows,
                    showSample: true,
                    category: category,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
