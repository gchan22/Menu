import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/menu_provider.dart';
import 'finalized_menu_item_row.dart';

class FinalizedMenuList extends ConsumerWidget {
  const FinalizedMenuList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMenuItems = ref.watch(menuProvider);

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: currentMenuItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = currentMenuItems[index];
        return FinalizedMenuItemRow(item: item);
      },
    );
  }
}