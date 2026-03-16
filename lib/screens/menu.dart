import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/menu_item_row.dart';
import 'finalized_menu.dart';
import '../models/menu_item.dart';
import '../providers/menu_provider.dart';

/// MenuScreen provides an interface to manage food categories (e.g., Chicken, Beef, Soda).
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

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
        label: 'Exit Editing',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addMenuItem(context, ref),
        backgroundColor: Colors.white70,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('New Category', style: TextStyle(color: Colors.black)),
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
                return MenuItemRow(item: item, index: index, allItems: menuItems);
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
}
