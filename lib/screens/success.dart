import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import 'restaurant.dart';
import 'choice_menu.dart';

/// SuccessScreen is displayed after a successful account creation.
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Success!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
