import 'package:flutter/material.dart';

/// A reusable widget that displays the thank you header text.
class ThankYouHeader extends StatelessWidget {
  const ThankYouHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Thank You',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}