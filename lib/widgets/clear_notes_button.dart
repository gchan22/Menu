import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_items_provider.dart';
import 'custom_button.dart';

class ClearNotesButton extends ConsumerWidget {
  final String category;

  const ClearNotesButton({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomButton(
      label: 'Clear Notes',
      onPressed: () {
        final itemsMap = ref.read(categoryItemsProvider).value ?? {};
        final currentItems = itemsMap[category] ?? [];
        final updatedItems = currentItems.map((item) {
          return item.copyWith(note: '');
        }).toList();
        ref.read(categoryItemsProvider.notifier).setCategoryItems(category, updatedItems);
      },
    );
  }
}