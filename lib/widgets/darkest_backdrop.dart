import 'package:flutter/material.dart';

/// DarkestBackdrop provides a very dark background with a gradient from dark red to black.
class DarkestBackdrop extends StatelessWidget {
  const DarkestBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 143, 10, 10), // Dark Red
            Color.fromARGB(255, 99, 5, 99), // dark purple
          ],
        ),
      ),
    );
  }
}
