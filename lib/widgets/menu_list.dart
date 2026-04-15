import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/menu_provider.dart';
import 'menu_item_row.dart';

class MenuList extends ConsumerWidget {
  const MenuList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(menuProvider);

    return ListView.separated(
      itemCount: menuItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return MenuItemRow(item: item, index: index, allItems: menuItems);
      },
    );
  }
}