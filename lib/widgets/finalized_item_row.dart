import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import '../providers/cart_provider.dart';
import '../providers/category_items_provider.dart';
import '../screens/finalized_description.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

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
                  if (i.name == item.name && i.price == item.price) {
                    return i.copyWith(note: noteController.text);
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
              // Customer can still add items to cart from the finalized view
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
          if (note != null && note.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      note,
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomButton(
                    label: '-',
                    onPressed: () {
                      final itemsMap = ref.read(categoryItemsProvider);
                      final currentItems = itemsMap[category] ?? [];
                      final updatedItems = currentItems.map((i) {
                        if (i.name == item.name && i.price == item.price) {
                          return i.copyWith(note: '');
                        }
                        return i;
                      }).toList();
                      ref.read(categoryItemsProvider.notifier).setCategoryItems(category, updatedItems);
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
