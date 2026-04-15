import 'package:flutter/material.dart';
import 'clear_notes_button.dart';
import 'custom_button.dart';
import '../screens/finalized_items.dart';

class ItemsBottomButtons extends StatelessWidget {
  final String category;

  const ItemsBottomButtons({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClearNotesButton(category: category),
        const SizedBox(width: 16),
        CustomButton(
          label: 'Exit Editing',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FinalizedItemsScreen(
                  category: category,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}