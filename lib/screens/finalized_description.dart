import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/description_display_row.dart';
import 'finalized_items.dart';
import '../providers/category_items_provider.dart';

/// FinalizedDescriptionScreen displays a read-only view of all description rows for a food item.
class FinalizedDescriptionScreen extends ConsumerWidget {
  final String itemName;
  final List<String> descriptionRows;
  final bool showSample;
  final String? category; // Category info used to navigate back correctly

  const FinalizedDescriptionScreen({
    super.key,
    required this.itemName,
    required this.descriptionRows,
    this.showSample = false,
    this.category,
  });

  /// The screen layout
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Explicit navigation back to the correct category item list
            if (category != null) {
              ref.read(categoryItemsProvider.notifier).initializeCategory(category!);
              final items = ref.read(categoryItemsProvider)[category!] ?? [];
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FinalizedItemsScreen(
                    category: category!,
                    items: items,
                  ),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                // Item Name title box
                DescriptionDisplayRow(text: itemName, isSample: true),
                const SizedBox(height: 20),
                // List of finalized description rows
                Expanded(
                  child: ListView.separated(
                    itemCount: descriptionRows.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return DescriptionDisplayRow(text: descriptionRows[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
