import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_items_provider.dart';
import '../models/category_item.dart';
import 'custom_text_field.dart';

class AddItemFab extends ConsumerWidget {
  final String category;

  const AddItemFab({super.key, required this.category});

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    String formatPrice(String input) {
      // Remove non-numeric characters except for the decimal point
      String cleaned = input.replaceAll(RegExp(r'[^0-9.]'), '');
      if (cleaned.isEmpty) return input;

      double? value = double.tryParse(cleaned);
      if (value == null) return input;

      // Format with commas and 2 decimal places
      String parts = value.toStringAsFixed(2);
      List<String> split = parts.split('.');
      String integerPart = split[0];
      String decimalPart = split[1];

      // Add commas to integer part
      RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      String formattedInteger = integerPart.replaceAllMapped(reg, (Match m) => '${m[1]},');

      return '\$$formattedInteger.$decimalPart';
    }

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
                  final formattedPrice = formatPrice(priceController.text);
                  ref.read(categoryItemsProvider.notifier).addCategoryItem(
                    category,
                    CategoryItemModel(
                      name: nameController.text,
                      price: formattedPrice,
                    ),
                  );
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddItemDialog(context, ref),
      icon: const Icon(Icons.add),
      label: const Text('Add New Item'),
    );
  }
}