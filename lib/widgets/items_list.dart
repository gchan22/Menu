import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_items_provider.dart';
import 'item_row.dart';

class ItemsList extends ConsumerWidget {
  final String category;

  const ItemsList({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsMap = ref.watch(categoryItemsProvider);
    final currentItems = itemsMap[category] ?? [];

    return ListView.separated(
      itemCount: currentItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = currentItems[index];
        return ItemRow(item: item, category: category);
      },
    );
  }
}