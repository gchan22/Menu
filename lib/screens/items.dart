import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import 'description.dart';

class ItemsScreen extends StatelessWidget {
  final String category;

  const ItemsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Items'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
            child: Column(
              children: [
                _buildItemRow(context, 'Sample Item 1', '\$10.00'),
                const SizedBox(height: 10),
                _buildItemRow(context, 'Sample Item 2', '\$12.00'),
                const SizedBox(height: 10),
                _buildItemRow(context, 'Sample Item 3', '\$15.00'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add item logic here
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, String name, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Text(price, style: const TextStyle(fontSize: 18, color: Colors.green)),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blueAccent),
            onPressed: () {
              // Do nothing for now
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DescriptionScreen(itemName: name),
                ),
              );
            },
            child: const Text('More Information'),
          ),
        ],
      ),
    );
  }
}
