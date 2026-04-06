import 'package:flutter/material.dart';

/// DarkBackdrop provides a dark background with a gradient from dark blue to dark green.
class DarkBackdrop extends StatelessWidget {
  const DarkBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 40, 131, 76), // Dark green
            Color.fromARGB(255, 55, 87, 139), // Dark blue
          ],
        ),
      ),
    );
  }
}
