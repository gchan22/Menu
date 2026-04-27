import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/cart_fab.dart';
import '../widgets/finalized_items_list.dart';
import '../widgets/clear_notes_button.dart';
import 'finalized_menu.dart';
import '../providers/menu_provider.dart';

/// FinalizedItemsScreen displays a read-only list of food items in a category for customers.
class FinalizedItemsScreen extends ConsumerWidget {
  final String category;

  const FinalizedItemsScreen({
    super.key,
    required this.category,
  });

  /// The screen layout
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMenu = ref.watch(menuProvider);
    final menuItems = asyncMenu.value ?? [];

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
            child: FinalizedItemsList(category: category),
          ),
          const Positioned(
            bottom: 16,
            left: 16,
            child: CartFAB(heroTag: 'cartFAB_finalized'),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: ClearNotesButton(category: category),
            ),
          ),
        ],
      ),
    );
  }
}
