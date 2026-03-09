import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import 'finalized_items.dart';
import '../cart_state.dart';

class FinalizedDescriptionScreen extends StatelessWidget {
  final String itemName;
  final List<String> descriptionRows;
  final bool showSample;
  final String? category; // Pass category to know where to go back

  const FinalizedDescriptionScreen({
    super.key,
    required this.itemName,
    required this.descriptionRows,
    this.showSample = true,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Description', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (category != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FinalizedItemsScreen(
                    category: category!,
                    items: CartState.itemsByCategory[category] ?? [],
                  ),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    itemName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (showSample) ...[
                  _buildDescriptionDisplayRow('Sample description', isSample: true),
                  const SizedBox(height: 10),
                ],
                Expanded(
                  child: ListView.separated(
                    itemCount: descriptionRows.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _buildDescriptionDisplayRow(descriptionRows[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionDisplayRow(String text, {bool isSample = false}) {
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
