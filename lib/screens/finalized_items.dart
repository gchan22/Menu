import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/finalized_item_row.dart';
import '../widgets/cart_fab.dart';
import 'finalized_menu.dart';
import '../models/category_item.dart';
import '../providers/cart_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/description_provider.dart';

/// FinalizedItemsScreen displays a read-only list of food items in a category for customers.
class FinalizedItemsScreen extends ConsumerWidget {
  final String category;
  final List<CategoryItemModel> items;

  const FinalizedItemsScreen({
    super.key,
    required this.category,
    required this.items,
  });

  /// The screen layout
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(menuProvider);
    final descriptionRowsMap = ref.watch(descriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Items', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Back navigation leads to the finalized menu category list
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FinalizedMenuScreen(
                  menuItems: menuItems,
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
            padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return FinalizedItemRow(
                  item: item,
                  category: category,
                  descriptionRows: descriptionRowsMap[item.name] ?? [],
                );
              },
            ),
          ),
          const Positioned(
            bottom: 16,
            left: 16,
            child: CartFAB(heroTag: 'cartFAB_finalized'),
          ),
        ],
      ),
    );
  }
}
