import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import '../providers/menu_provider.dart';
import 'custom_text_field.dart';

class AddCategoryFab extends ConsumerWidget {
  const AddCategoryFab({super.key});

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
                      Column(
                        mainAxisSize: MainAxisSize.min,
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
                          const Text('Food'),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.local_drink,
                              color: selectedIcon == Icons.local_drink ? Colors.blue : Colors.black,
                            ),
                            onPressed: () {
                              setDialogState(() => selectedIcon = Icons.local_drink);
                            },
                          ),
                          const Text('Drink'),
                        ],
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
    return FloatingActionButton.extended(
      onPressed: () => _addMenuItem(context, ref),
      backgroundColor: Colors.white70,
      icon: const Icon(Icons.add, color: Colors.black),
      label: const Text('New Category', style: TextStyle(color: Colors.black)),
    );
  }
}