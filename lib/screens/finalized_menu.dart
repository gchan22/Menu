import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import 'finalized_items.dart';
import 'finalized_restaurant.dart';
import '../cart_state.dart';
import '../models/menu_item.dart';
import '../models/category_item.dart';

/// FinalizedMenuScreen displays a read-only list of menu categories for customers to browse.
class FinalizedMenuScreen extends StatelessWidget {
  final List<MenuItemModel> menuItems;

  const FinalizedMenuScreen({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
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
                  restaurantName: CartState.restaurantName,
                  slogan: CartState.slogan,
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
              itemCount: menuItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return _buildMenuItemRow(context, item);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a UI row for a single menu category in the finalized view.
  Widget _buildMenuItemRow(BuildContext context, MenuItemModel item) {
    return Row(
      children: [
        Icon(item.icon, size: 30, color: Colors.white),
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
                Text(
                  item.label,
                  style: const TextStyle(fontSize: 18),
                ),
                // Button to view finalized items within this category
                CustomButton(
                  label: 'Food Items',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FinalizedItemsScreen(
                          category: item.label,
                          items: CartState.itemsByCategory[item.label] ?? [
                            CategoryItemModel(name: 'Sample Item 1', price: '\$10.00'),
                            CategoryItemModel(name: 'Sample Item 2', price: '\$12.00'),
                            CategoryItemModel(name: 'Sample Item 3', price: '\$15.00'),
                          ],
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
