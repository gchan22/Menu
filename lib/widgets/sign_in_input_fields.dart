import 'package:flutter/material.dart';
import 'custom_text_field.dart';

/// A reusable widget that holds the sign in input fields (email/username and password).
class SignInInputFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onTogglePasswordVisibility;
  final String? Function(String?)? usernameValidator;
  final String? Function(String?)? passwordValidator;

  const SignInInputFields({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onTogglePasswordVisibility,
    this.usernameValidator,
    this.passwordValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: usernameController,
          label: 'Email or Username',
          validator: usernameValidator,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: passwordController,
          label: 'Password',
          obscureText: !isPasswordVisible,
          validator: passwordValidator,
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: onTogglePasswordVisibility,
          ),
        ),
      ],
    );
  }
}