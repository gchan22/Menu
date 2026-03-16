import 'package:flutter/material.dart';

/// An individual editable row for description text with a delete button.
class DescriptionInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  const DescriptionInputRow({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null, // Allows the text field to grow vertically
              onChanged: (_) => onChanged(),
              decoration: const InputDecoration(
                hintText: 'Enter description...',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          // Button to remove this specific row
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
