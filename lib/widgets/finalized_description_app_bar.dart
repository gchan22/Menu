import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/finalized_items.dart';
import '../providers/category_items_provider.dart';

/// A custom app bar for the finalized description screen with specific back navigation.
class FinalizedDescriptionAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? category;

  const FinalizedDescriptionAppBar({
    super.key,
    this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('Description', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          // Explicit navigation back to the correct category item list
          if (category != null) {
            ref.read(categoryItemsProvider.notifier).initializeCategory(category!);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FinalizedItemsScreen(
                  category: category!,
                ),
              ),
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}