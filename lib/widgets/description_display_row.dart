import 'dart:convert';
import 'package:flutter/material.dart';

/// A read-only UI row for a single piece of item description (text or image).
class DescriptionDisplayRow extends StatelessWidget {
  final String text;
  final bool isSample;

  const DescriptionDisplayRow({
    super.key,
    required this.text,
    this.isSample = false,
  });

  /// Add a image as a row.
  @override
  Widget build(BuildContext context) {
    if (text.startsWith('IMAGE:')) {
      final base64Image = text.substring(6);
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.memory(
          base64Decode(base64Image),
          fit: BoxFit.contain,
          height: 200,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
        ),
      );
    }

    // Default to text if not an image
    final displayMainText = text.startsWith('TEXT:') ? text.substring(5) : text;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayMainText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isSample ? 18 : 16,
        ),
      ),
    );
  }
}
