import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'items.dart';
import 'finalized_menu.dart';
import '../models/menu_item.dart';
import '../providers/menu_provider.dart';

/// MenuScreen provides an interface to manage food categories (e.g., Chicken, Beef, Soda).
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  /// Displays a dialog allowing the user to change the icon for a menu category.
  void _pickIcon(BuildContext context, WidgetRef ref, int index, List<MenuItemModel> menuItems) {
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
                  final newItem = MenuItemModel(icon: Icons.restaurant, label: menuItems[index].label);
                  final newList = List<MenuItemModel>.from(menuItems)..[index] = newItem;
                  ref.read(menuProvider.notifier).state = newList;
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.local_drink),
                onPressed: () {
                  final newItem = MenuItemModel(icon: Icons.local_drink, label: menuItems[index].label);
                  final newList = List<MenuItemModel>.from(menuItems)..[index] = newItem;
                  ref.read(menuProvider.notifier).state = newList;
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.fastfood),
                onPressed: () {
                  final newItem = MenuItemModel(icon: Icons.fastfood, label: menuItems[index].label);
                  final newList = List<MenuItemModel>.from(menuItems)..[index] = newItem;
                  ref.read(menuProvider.notifier).state = newList;
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.icecream),
                onPressed: () {
                  final newItem = MenuItemModel(icon: Icons.icecream, label: menuItems[index].label);
                  final newList = List<MenuItemModel>.from(menuItems)..[index] = newItem;
                  ref.read(menuProvider.notifier).state = newList;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Displays a dialog to add a new menu category with a name and icon.
  void _addMenuItem(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    IconData selectedIcon = Icons.restaurant;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Menu Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    controller: controller,
                    label: 'Item Name',
                    filled: false,
                  ),
                  const SizedBox(height: 20),
                  const Text('Select Icon:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.restaurant,
                          color: selectedIcon == Icons.restaurant ? Colors.blue : Colors.black,
                        ),
                        onPressed: () {
                          setDialogState(() => selectedIcon = Icons.restaurant);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.local_drink,
                          color: selectedIcon == Icons.local_drink ? Colors.blue : Colors.black,
                        ),
                        onPressed: () {
                          setDialogState(() => selectedIcon = Icons.local_drink);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      ref.read(menuProvider.notifier).addMenuItem(MenuItemModel(
                        icon: selectedIcon,
                        label: controller.text,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(menuProvider);

    // Navigation button to the finalized menu view
    final exitButton = Center(
      child: CustomButton(
        label: 'Exit',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinalizedMenuScreen(menuItems: menuItems),
            ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMenuItem(context, ref),
        backgroundColor: Colors.white70,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 80),
            child: ListView.separated(
              itemCount: menuItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return _buildMenuItemRow(context, ref, item, index, menuItems);
              },
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: exitButton,
          ),
        ],
      ),
    );
  }

  /// Builds a row representing a single menu category.
  Widget _buildMenuItemRow(BuildContext context, WidgetRef ref, MenuItemModel item, int index, List<MenuItemModel> menuItems) {
    return Row(
      children: [
        IconButton(
          icon: Icon(item.icon, size: 30, color: Colors.white),
          onPressed: () => _pickIcon(context, ref, index, menuItems),
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
                Text(
                  item.label,
                  style: const TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    CustomButton(
                      label: 'Food Items',
                      onPressed: () {
                        // Navigate to specific items within this category
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemsScreen(category: item.label),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    // Button to remove the category
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
