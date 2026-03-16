import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import 'finalized_menu.dart';
import 'sign_in.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';

/// FinalizedRestaurantScreen displays a read-only preview of the restaurant name and slogan.
class FinalizedRestaurantScreen extends ConsumerWidget {
  final String restaurantName;
  final String slogan;

  const FinalizedRestaurantScreen({
    super.key,
    required this.restaurantName,
    required this.slogan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(restaurantInfoProvider);
    final menuItems = ref.watch(menuProvider);

    // A special button to return to the setup screen and start over
    final newMenuButton = Positioned(
      top: 40,
      left: 16,
      child: CustomButton(
        label: 'Sign In',
        backgroundColor: const Color.fromARGB(255, 242, 109, 153),
        foregroundColor: Colors.black,
        onPressed: () {
          // Clears navigation stack and goes to the sign in screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          );
        },
      ),
    );

    // Displays the restaurant name in a styled container
    final restaurantNameBox = _buildInfoBox(
      text: info.name.isNotEmpty ? info.name : restaurantName,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    // Displays the slogan in a styled container
    final sloganBox = _buildInfoBox(
      text: info.slogan.isNotEmpty ? info.slogan : slogan,
      fontSize: 18,
      fontStyle: FontStyle.italic,
    );

    // Button to proceed to the finalized menu viewing screen
    final startEatingButton = CustomButton(
      label: 'Start Eating',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinalizedMenuScreen(
              menuItems: menuItems,
            ),
          ),
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                restaurantNameBox,
                const SizedBox(height: 20),
                sloganBox,
                const SizedBox(height: 40),
                startEatingButton,
              ],
            ),
          ),
          newMenuButton, // Move to bottom to be on top
        ],
      ),
    );
  }

  /// Helper to build a generic styled container for finalized text information.
  Widget _buildInfoBox({
    required String text,
    required double fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
        ),
      ),
    );
  }
}
