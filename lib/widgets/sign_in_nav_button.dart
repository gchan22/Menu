import 'package:flutter/material.dart';
import '../screens/sign_in.dart';
import 'custom_button.dart';

class SignInNavButton extends StatelessWidget {
  const SignInNavButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
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
    );
  }
}