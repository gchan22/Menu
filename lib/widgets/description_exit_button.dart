import 'package:flutter/material.dart';
import 'custom_button.dart';
import '../models/description_item.dart';
import '../screens/finalized_description.dart';

/// A widget that contains the exit editing button and navigation logic for the description screen.
class DescriptionExitButton extends StatelessWidget {
  final String itemName;
  final String category;
  final List<DescriptionItem> descriptionItems;
  final VoidCallback onSave;

  const DescriptionExitButton({
    super.key,
    required this.itemName,
    required this.category,
    required this.descriptionItems,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      label: 'Exit Editing',
      onPressed: () {
        onSave();
        // Navigate to the finalized preview of the item description
        final List<String> finalRows = [];
        for (var item in descriptionItems) {
          if (item.isImage && item.imageData != null) {
            finalRows.add('IMAGE:${item.imageData}');
          } else if (!item.isImage && item.controller != null && item.controller!.text.isNotEmpty) {
            finalRows.add('TEXT:${item.controller!.text}');
          }
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinalizedDescriptionScreen(
              itemName: itemName,
              descriptionRows: finalRows,
              showSample: false,
              category: category,
            ),
          ),
        );
      },
    );
  }
}