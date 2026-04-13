import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/finalized_description_app_bar.dart';
import '../widgets/finalized_description_list.dart';

/// FinalizedDescriptionScreen displays a read-only view of all description rows for a food item.
class FinalizedDescriptionScreen extends StatelessWidget {
  final String itemName;
  final List<String> descriptionRows;
  final bool showSample;
  final String? category; // Category info used to navigate back correctly

  const FinalizedDescriptionScreen({
    super.key,
    required this.itemName,
    required this.descriptionRows,
    this.showSample = false,
    this.category,
  });

  /// The screen layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FinalizedDescriptionAppBar(category: category),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          FinalizedDescriptionList(
            itemName: itemName,
            descriptionRows: descriptionRows,
          ),
        ],
      ),
    );
  }
}
