import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import 'finalized_description.dart';
import '../models/cart_state.dart';

/// DescriptionScreen allows users to add and edit multiple text rows describing a specific food item.
class DescriptionScreen extends StatefulWidget {
  final String itemName;
  final String category; // Used for navigation back to the correct category list

  const DescriptionScreen({
    super.key,
    required this.itemName,
    required this.category,
  });

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  // A list of controllers to manage each dynamic description text field
  final List<TextEditingController> _descriptionControllers = [];

  @override
  void initState() {
    super.initState();
    // Pre-populate with existing descriptions from global state
    final existingRows = CartState.descriptionRowsByItem[widget.itemName] ?? [];
    for (var row in existingRows) {
      _descriptionControllers.add(TextEditingController(text: row));
    }
  }

  @override
  void dispose() {
    // Dispose all dynamic controllers to prevent memory leaks
    for (var controller in _descriptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Saves all non-empty description rows to the global state.
  void _saveData() {
    CartState.updateDescriptionRows(
      widget.itemName,
      _descriptionControllers.map((c) => c.text).toList(),
    );
  }

  /// Adds a new empty text field for a new description row.
  void _addTextBox() {
    setState(() {
      _descriptionControllers.add(TextEditingController());
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Description'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 80),
            child: Column(
              children: [
                // Item Name title
                Text(
                  widget.itemName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Dynamic list of description input rows
                Expanded(
                  child: ListView.separated(
                    itemCount: _descriptionControllers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _buildDescriptionInputRow(index);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Exit button at the bottom center
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: CustomButton(
                label: 'Exit',
                onPressed: () {
                  _saveData();
                  // Navigate to the finalized preview of the item description
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinalizedDescriptionScreen(
                        itemName: widget.itemName,
                        descriptionRows: _descriptionControllers
                            .map((c) => c.text)
                            .where((t) => t.isNotEmpty)
                            .toList(),
                        showSample: false,
                        category: widget.category,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // Floating action button to add more description rows
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTextBox,
        label: const Text('Add Description'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  /// Builds an individual editable row for description text with a delete button.
  Widget _buildDescriptionInputRow(int index) {
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
              controller: _descriptionControllers[index],
              maxLines: null, // Allows the text field to grow vertically
              onChanged: (_) => _saveData(),
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
            onPressed: () {
              setState(() {
                _descriptionControllers[index].dispose();
                _descriptionControllers.removeAt(index);
              });
              _saveData();
            },
          ),
        ],
      ),
    );
  }
}
