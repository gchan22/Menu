import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import '../providers/menu_provider.dart';
import '../screens/items.dart';
import 'custom_button.dart';

/// A row representing a single menu category in the editing screen.
class MenuItemRow extends ConsumerWidget {
  final MenuItemModel item;
  final int index;
  final List<MenuItemModel> allItems;

  const MenuItemRow({
    super.key,
    required this.item,
    required this.index,
    required this.allItems,
  });

  /// Displays a dialog allowing the user to change the icon for a menu category.
  void _pickIcon(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Icon'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.restaurant),
                onPressed: () {
                  final newItem = MenuItemModel(icon: Icons.restaurant, label: item.label);
                  ref.read(menuProvider.notifier).updateMenuItem(index, newItem);
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.local_drink),
                onPressed: () {
                  final newItem = MenuItemModel(icon: Icons.local_drink, label: item.label);
                  ref.read(menuProvider.notifier).updateMenuItem(index, newItem);
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.fastfood),
                onPressed: () {
                  final newItem = MenuItemModel(icon: Icons.fastfood, label: item.label);
                  ref.read(menuProvider.notifier).updateMenuItem(index, newItem);
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.icecream),
                onPressed: () {
                  final newItem = MenuItemModel(icon: Icons.icecream, label: item.label);
                  ref.read(menuProvider.notifier).updateMenuItem(index, newItem);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        IconButton(
          icon: Icon(item.icon, size: 30, color: Colors.black87),
          onPressed: () => _pickIcon(context, ref),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      label: 'Food Items',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemsScreen(category: item.label),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        ref.read(menuProvider.notifier).removeMenuItem(item);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
