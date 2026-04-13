import 'package:flutter/material.dart';
import 'custom_button.dart';
import '../screens/sign_in.dart';

/// A widget that contains the action buttons for the create account form.
class CreateAccountActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCreateAccount;

  const CreateAccountActionButtons({
    super.key,
    required this.isLoading,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading)
          const CircularProgressIndicator(color: Colors.white)
        else
          CustomButton(
            label: 'Create Account',
            onPressed: onCreateAccount,
          ),
        const SizedBox(height: 20),
        CustomButton(
          label: 'Back to Sign In',
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          ),
        ),
      ],
    );
  }
}