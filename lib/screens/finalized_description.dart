import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
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
    this.showSample = true,
    this.category,
  });

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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    itemName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Optional sample description row
                if (showSample) ...[
                  _buildDescriptionDisplayRow('Sample description', isSample: true),
                  const SizedBox(height: 10),
                ],
                // List of finalized description rows
                Expanded(
                  child: ListView.separated(
                    itemCount: descriptionRows.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _buildDescriptionDisplayRow(descriptionRows[index]);
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

  /// Builds a read-only UI row for a single piece of item description.
  Widget _buildDescriptionDisplayRow(String text, {bool isSample = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isSample ? 18 : 16,
        ),
      ),
    );
  }
}
