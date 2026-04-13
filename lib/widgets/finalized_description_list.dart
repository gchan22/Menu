import 'package:flutter/material.dart';
import 'description_display_row.dart';

/// A widget that displays the finalized (read-only) list of an item's descriptions.
class FinalizedDescriptionList extends StatelessWidget {
  final String itemName;
  final List<String> descriptionRows;

  const FinalizedDescriptionList({
    super.key,
    required this.itemName,
    required this.descriptionRows,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          // Item Name title box
          DescriptionDisplayRow(text: itemName, isSample: true),
          const SizedBox(height: 20),
          // List of finalized description rows
          Expanded(
            child: ListView.separated(
              itemCount: descriptionRows.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return DescriptionDisplayRow(text: descriptionRows[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}