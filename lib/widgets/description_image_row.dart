import 'dart:convert';
import 'package:flutter/material.dart';

/// A widget that displays a base64 encoded image with a delete button.
class DescriptionImageRow extends StatelessWidget {
  final String imageData;
  final VoidCallback onDelete;

  const DescriptionImageRow({
    super.key,
    required this.imageData,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Image.memory(
              base64Decode(imageData),
              fit: BoxFit.contain,
              height: 200,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}