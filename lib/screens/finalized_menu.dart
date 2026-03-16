import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import 'finalized_items.dart';
import 'finalized_restaurant.dart';
import '../models/menu_item.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/category_items_provider.dart';

/// FinalizedMenuScreen displays a read-only list of menu categories for customers to browse.
class FinalizedMenuScreen extends ConsumerWidget {
  final List<MenuItemModel> menuItems;

  const FinalizedMenuScreen({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(restaurantInfoProvider);
    final currentMenuItems = ref.watch(menuProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Navigation back leads explicitly to the finalized restaurant preview
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FinalizedRestaurantScreen(
                  restaurantName: info.name,
                  slogan: info.slogan,
                ),
              ),
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 16),
            child: ListView.separated(
              itemCount: currentMenuItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = currentMenuItems[index];
                return _buildMenuItemRow(context, ref, item);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a UI row for a single menu category in the finalized view.
  Widget _buildMenuItemRow(BuildContext context, WidgetRef ref, MenuItemModel item) {
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
                    final items = ref.read(categoryItemsProvider)[item.label] ?? [];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FinalizedItemsScreen(
                          category: item.label,
                          items: items,
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
