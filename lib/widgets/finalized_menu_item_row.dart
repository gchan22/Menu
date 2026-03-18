import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import '../providers/category_items_provider.dart';
import '../screens/finalized_items.dart';
import 'custom_button.dart';

/// A UI row for a single menu category in the finalized view.
class FinalizedMenuItemRow extends ConsumerWidget {
  final MenuItemModel item;

  const FinalizedMenuItemRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Icon(item.icon, size: 30, color: Colors.black87),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Button to view finalized items within this category
                CustomButton(
                  label: 'Food Items',
                  onPressed: () {
                    ref.read(categoryItemsProvider.notifier).initializeCategory(item.label);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FinalizedItemsScreen(
                          category: item.label,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
