import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import 'restaurant.dart';

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
                        // This button currently does nothing as per prompt 61
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
