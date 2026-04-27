import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/menu_provider.dart';
import '../screens/finalized_menu.dart';
import 'custom_button.dart';

class ExitEditingMenuButton extends ConsumerWidget {
  const ExitEditingMenuButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMenu = ref.watch(menuProvider);
    final menuItems = asyncMenu.value ?? [];

    return Center(
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
  }
}