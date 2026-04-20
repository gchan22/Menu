import 'package:flutter/material.dart';
import 'custom_button.dart';
import '../screens/create_account.dart';

/// A reusable widget containing the primary action buttons for the sign in screen.
class SignInActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSignIn;

  const SignInActionButtons({
    super.key,
    required this.isLoading,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const CircularProgressIndicator(color: Colors.white);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          label: 'Sign In',
          onPressed: onSignIn,
        ),
        const SizedBox(width: 20),
        CustomButton(
          label: 'Create Account',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
            );
          },
        ),
      ],
    );
  }
}