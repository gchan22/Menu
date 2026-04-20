import 'package:flutter/material.dart';
import 'custom_button.dart';

/// A reusable widget containing the primary action buttons for the restaurant screen.
class RestaurantActionButtons extends StatelessWidget {
  final VoidCallback onExitEditing;
  final VoidCallback onEditMenu;

  const RestaurantActionButtons({
    super.key,
    required this.onExitEditing,
    required this.onEditMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          label: 'Exit Editing',
          onPressed: onExitEditing,
        ),
        const SizedBox(width: 20),
        CustomButton(
          label: 'Edit Menu',
          onPressed: onEditMenu,
        ),
      ],
    );
  }
}