import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/menu_list.dart';
import '../widgets/exit_editing_menu_button.dart';
import '../widgets/add_category_fab.dart';

/// MenuScreen provides an interface to manage food categories (e.g., Chicken, Beef, Soda).
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      floatingActionButton: const AddCategoryFab(),
      body: Stack(
        children: [
          const Backdrop(),
          const Padding(
            padding: EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 80),
            child: MenuList(),
          ),
          const Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: ExitEditingMenuButton(),
          ),
        ],
      ),
    );
  }
}
