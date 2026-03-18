import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/item_row.dart';
import '../widgets/cart_fab.dart';
import 'finalized_items.dart';
import '../models/category_item.dart';
import '../providers/category_items_provider.dart';

/// ItemsScreen displays and manages a list of food items within a specific category.
class ItemsScreen extends ConsumerStatefulWidget {
  final String category;

  const ItemsScreen({super.key, required this.category});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize category with defaults if it doesn't exist yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryItemsProvider.notifier).initializeCategory(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes in items for this specific category
    final itemsMap = ref.watch(categoryItemsProvider);
    final currentItems = itemsMap[widget.category] ?? [];

    // Button to exit editing and view the finalized items list
    final exitButton = Center(
      child: CustomButton(
        label: 'Exit Editing',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinalizedItemsScreen(
                category: widget.category,
                items: currentItems,
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
              itemCount: currentItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = currentItems[index];
                return ItemRow(item: item, category: widget.category);
              },
            ),
          ),
          const Positioned(
            bottom: 16,
            left: 16,
            child: CartFAB(heroTag: 'cartFAB'),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: exitButton,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddItemDialog(context, ref);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add New Item'),
      ),
    );
  }

  /// Displays a dialog to add a new food item with a name and price.
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
                    widget.category,
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
}
