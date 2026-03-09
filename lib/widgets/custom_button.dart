import 'package:flutter/material.dart';

/// A reusable ElevatedButton wrapper with optional styling for background and text colors.
class CustomButton extends StatelessWidget {
  /// The text to display on the button.
  final String label;
  /// The callback function when the button is pressed.
  final VoidCallback onPressed;
  /// Optional background color.
  final Color? backgroundColor;
  /// Optional foreground (text/icon) color.
  final Color? foregroundColor;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
