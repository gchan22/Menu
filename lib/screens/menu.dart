import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'items.dart';
import 'finalized_menu.dart';
import '../models/cart_state.dart';
import '../models/menu_item.dart';

/// MenuScreen provides an interface to manage food categories (e.g., Chicken, Beef, Soda).
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late List<MenuItemModel> _menuItems;

  @override
  void initState() {
    super.initState();
    // Load menu categories from global state
    _menuItems = List.from(CartState.menuItems);
  }

  /// Syncs local menu changes to the global CartState.
  void _saveData() {
    CartState.updateMenuItems(_menuItems);
  }

  /// Displays a dialog allowing the user to change the icon for a menu category.
  void _pickIcon(int index) {
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
                  setState(() => _menuItems[index] = MenuItemModel(icon: Icons.restaurant, label: _menuItems[index].label));
                  _saveData();
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.local_drink),
                onPressed: () {
                  setState(() => _menuItems[index] = MenuItemModel(icon: Icons.local_drink, label: _menuItems[index].label));
                  _saveData();
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.fastfood),
                onPressed: () {
                  setState(() => _menuItems[index] = MenuItemModel(icon: Icons.fastfood, label: _menuItems[index].label));
                  _saveData();
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.icecream),
                onPressed: () {
                  setState(() => _menuItems[index] = MenuItemModel(icon: Icons.icecream, label: _menuItems[index].label));
                  _saveData();
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
  void _addMenuItem() {
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
                      setState(() {
                        _menuItems.add(MenuItemModel(
                          icon: selectedIcon,
                          label: controller.text,
                        ));
                      });
                      _saveData();
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
  Widget build(BuildContext context) {
    // Navigation button to the finalized menu view
    final exitButton = Center(
      child: CustomButton(
        label: 'Exit',
        onPressed: () {
          _saveData();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinalizedMenuScreen(menuItems: _menuItems),
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
        onPressed: _addMenuItem,
        backgroundColor: Colors.white70,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 80),
            child: ListView.separated(
              itemCount: _menuItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return _buildMenuItemRow(item, index);
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
  Widget _buildMenuItemRow(MenuItemModel item, int index) {
    return Row(
      children: [
        IconButton(
          icon: Icon(item.icon, size: 30, color: Colors.white),
          onPressed: () => _pickIcon(index),
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
                        _saveData();
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
                        setState(() {
                          _menuItems.removeAt(index);
                        });
                        _saveData();
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
