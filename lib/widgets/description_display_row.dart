import 'package:flutter/material.dart';

/// A read-only UI row for a single piece of item description.
class DescriptionDisplayRow extends StatelessWidget {
  final String text;
  final bool isSample;

  const DescriptionDisplayRow({
    super.key,
    required this.text,
    this.isSample = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isSample ? 18 : 16,
        ),
      ),
    );
  }
}
