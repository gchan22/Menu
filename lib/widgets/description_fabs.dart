import 'package:flutter/material.dart';

/// A widget containing the floating action buttons for adding pictures and descriptions.
class DescriptionFabs extends StatelessWidget {
  final VoidCallback onAddPicture;
  final VoidCallback onAddDescription;

  const DescriptionFabs({
    super.key,
    required this.onAddPicture,
    required this.onAddDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.extended(
          heroTag: 'add_picture_fab',
          onPressed: onAddPicture,
          label: const Text('+ Add Picture'),
          icon: const Icon(Icons.add_a_photo),
        ),
        const SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: 'add_description_fab',
          onPressed: onAddDescription,
          label: const Text('+ Add Description'),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}