import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import 'items.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMenuRow(context, Icons.restaurant, 'Chicken'),
                const SizedBox(height: 10),
                _buildMenuRow(context, Icons.restaurant, 'Beef'),
                const SizedBox(height: 10),
                _buildMenuRow(context, Icons.restaurant, 'Pork'),
                const SizedBox(height: 10),
                _buildMenuRow(context, Icons.local_drink, 'Soda'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.white),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemsScreen(category: label),
              ),
            );
          },
        ),
      ],
    );
  }
}
