import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import 'items.dart';

class FinalizedMenuScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems;

  const FinalizedMenuScreen({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalized Menu'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 16),
            child: ListView.separated(
              itemCount: menuItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return Row(
                  children: [
                    Icon(item['icon'], size: 30, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['label'],
                              style: const TextStyle(fontSize: 18),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemsScreen(category: item['label']),
                                  ),
                                );
                              },
                              child: const Text('Food Items'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
