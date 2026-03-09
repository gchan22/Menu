import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import 'finalized_menu.dart';
import 'restaurant.dart';
import '../cart_state.dart';

class FinalizedRestaurantScreen extends StatelessWidget {
  final String restaurantName;
  final String slogan;

  const FinalizedRestaurantScreen({
    super.key,
    required this.restaurantName,
    required this.slogan,
  });

  @override
  Widget build(BuildContext context) {
    final newMenuButton = Positioned(
      top: 40,
      left: 16,
      child: CustomButton(
        label: 'New Menu',
        backgroundColor: const Color.fromARGB(255, 242, 109, 153),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const RestaurantScreen()),
            (route) => false,
          );
        },
      ),
    );

    final restaurantNameBox = _buildInfoBox(
      text: restaurantName,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    final sloganBox = _buildInfoBox(
      text: slogan,
      fontSize: 18,
      fontStyle: FontStyle.italic,
    );

    final startEatingButton = CustomButton(
      label: 'Start Eating',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinalizedMenuScreen(
              menuItems: CartState.menuItems,
            ),
          ),
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(),
          newMenuButton,
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
        ],
      ),
    );
  }

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
