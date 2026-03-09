import 'package:flutter/material.dart';

class DescriptionInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onRemove;
  final ValueChanged<String> onChanged;

  const DescriptionInputRow({
    super.key,
    required this.controller,
    required this.onRemove,
    required this.onChanged,
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
              maxLines: null,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Enter description...',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
