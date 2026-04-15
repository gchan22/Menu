import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/cart_fab.dart';
import '../providers/category_items_provider.dart';
import '../widgets/items_list.dart';
import '../widgets/items_bottom_buttons.dart';
import '../widgets/add_item_fab.dart';

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
            child: ItemsList(category: widget.category),
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
            child: ItemsBottomButtons(category: widget.category),
          ),
        ],
      ),
      floatingActionButton: AddItemFab(category: widget.category),
    );
  }
}
