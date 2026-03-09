import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool filled;
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
