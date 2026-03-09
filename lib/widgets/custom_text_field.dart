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

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.filled = true,
    this.fillColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        filled: filled,
        fillColor: fillColor,
      ),
    );
  }
}
