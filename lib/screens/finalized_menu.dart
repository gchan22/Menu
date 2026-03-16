import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/finalized_menu_item_row.dart';
import 'finalized_restaurant.dart';
import '../models/menu_item.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';

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
                return FinalizedMenuItemRow(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
