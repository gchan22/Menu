import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';

class FinalizedDescriptionScreen extends StatelessWidget {
  final String itemName;
  final List<String> descriptionRows;
  final bool showSample;

  const FinalizedDescriptionScreen({
    super.key,
    required this.itemName,
    required this.descriptionRows,
    this.showSample = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalized Description'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Sample description',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Expanded(
                  child: ListView.separated(
                    itemCount: descriptionRows.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          descriptionRows[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      );
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
}
