import 'package:flutter/material.dart';
import '../models/description_item.dart';
import 'description_image_row.dart';
import 'description_input_row.dart';

/// A widget that displays the list of description input rows and images.
class DescriptionListView extends StatelessWidget {
  final List<DescriptionItem> items;
  final Function(int) onDelete;
  final VoidCallback onSave;

  const DescriptionListView({
    super.key,
    required this.items,
    required this.onDelete,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          if (item.isImage) {
            return DescriptionImageRow(
              imageData: item.imageData!,
              onDelete: () => onDelete(index),
            );
          } else {
            return DescriptionInputRow(
              controller: item.controller!,
              onChanged: onSave,
              onDelete: () => onDelete(index),
            );
          }
        },
      ),
    );
  }
}