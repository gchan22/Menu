import 'package:flutter/material.dart';

/// A reusable widget that displays the success icon and text.
class SuccessHeader extends StatelessWidget {
  const SuccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 100,
        ),
        const SizedBox(height: 20),
        const Text(
          'Success!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}