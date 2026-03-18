import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import '../providers/cart_provider.dart';
import '../providers/category_items_provider.dart';
import '../screens/description.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

/// A UI row for an individual food item in the items editing screen.
class ItemRow extends ConsumerWidget {
  final CategoryItemModel item;
  final String category;

  const ItemRow({
    super.key,
    required this.item,
    required this.category,
  });

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final noteController = TextEditingController(text: item.note);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: CustomTextField(
            controller: noteController,
            label: 'Note',
            filled: false,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final itemsMap = ref.read(categoryItemsProvider);
                final currentItems = itemsMap[category] ?? [];
                final updatedItems = currentItems.map((i) {
                  if (i == item) {
                    return CategoryItemModel(
                      name: i.name,
                      price: i.price,
                      note: noteController.text,
                    );
                  }
                  return i;
                }).toList();
                ref.read(categoryItemsProvider.notifier).setCategoryItems(category, updatedItems);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = item.name;
    final price = item.price;
    final note = item.note;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Text(price, style: const TextStyle(fontSize: 18, color: Colors.green)),
              const SizedBox(width: 8),
              // Add Note button
              CustomButton(
                label: 'Add Note',
                onPressed: () => _showAddNoteDialog(context, ref),
              ),
              const SizedBox(width: 8),
              // Add to cart button
              CustomButton(
                label: '+ Add to Cart',
                onPressed: () {
                  ref.read(cartProvider.notifier).addItem(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name added to cart!'), duration: const Duration(seconds: 1)),
                  );
                },
              ),
              const SizedBox(width: 8),
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
          if (note != null && note.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                note,
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }
}
