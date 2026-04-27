import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_items_provider.dart';
import '../providers/description_provider.dart';
import 'finalized_item_row.dart';

class FinalizedItemsList extends ConsumerWidget {
  final String category;

  const FinalizedItemsList({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryItemsAsync = ref.watch(categoryItemsProvider);
    final descriptionRowsAsync = ref.watch(descriptionProvider);

    return categoryItemsAsync.when(
      data: (categoryItemsMap) {
        final descriptionRowsMap = descriptionRowsAsync.value ?? {};
        final items = categoryItemsMap[category] ?? [];

        return ListView.separated(
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
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Center(child: Text('Error loading items')),
    );
  }
}