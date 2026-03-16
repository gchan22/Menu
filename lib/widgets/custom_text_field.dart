import 'package:flutter/material.dart';

/// A reusable TextField wrapper with consistent styling for the application.
class CustomTextField extends StatelessWidget {
  /// The controller managing the text being edited.
  final TextEditingController controller;
  /// The label text shown inside or above the text field.
  final String label;
  /// Whether the background of the text field should be filled.
  final bool filled;
  /// The color used to fill the background.
  final Color? fillColor;
  /// Whether to hide the text being entered (e.g., for passwords).
  final bool obscureText;
  /// A validation function for the input text.
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.filled = true,
    this.fillColor = Colors.white70,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        filled: filled,
        fillColor: fillColor,
      ),
    );
  }
}
