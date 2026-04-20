import 'package:flutter/material.dart';
import 'custom_button.dart';
import '../screens/restaurant.dart';
import '../screens/choice_menu.dart';

/// A reusable widget containing the action buttons for the success screen.
class SuccessActionButtons extends StatelessWidget {
  const SuccessActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          label: 'Continue Edit',
          onPressed: () {
            // Navigate to the restaurant setup screen
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const RestaurantScreen()),
              (route) => false,
            );
          },
        ),
        const SizedBox(width: 20),
        CustomButton(
          label: 'New Menu',
          onPressed: () {
            // Navigate to choice_menu screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ChoiceMenuScreen()),
            );
          },
        ),
      ],
    );
  }
}