import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';

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
                _buildMenuRow(Icons.restaurant, 'Chicken'),
                const SizedBox(height: 10),
                _buildMenuRow(Icons.restaurant, 'Beef'),
                const SizedBox(height: 10),
                _buildMenuRow(Icons.restaurant, 'Pork'),
                const SizedBox(height: 10),
                _buildMenuRow(Icons.local_drink, 'Soda'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow(IconData icon, String label) {
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
      ],
    );
  }
}
