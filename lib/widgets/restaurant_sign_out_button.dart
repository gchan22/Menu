import 'package:flutter/material.dart';
import 'custom_button.dart';
import '../screens/sign_in.dart';

/// A reusable widget that positions the sign out button on the screen.
class RestaurantSignOutButton extends StatelessWidget {
  final VoidCallback onSignOut;

  const RestaurantSignOutButton({
    super.key,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 16,
      child: CustomButton(
        label: 'Sign Out',
        onPressed: () {
          onSignOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          );
        },
      ),
    );
  }
}