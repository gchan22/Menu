import 'package:flutter/material.dart';

/// LightBackdrop provides a light background with a gradient from yellow to pink.
class LightBackdrop extends StatelessWidget {
  const LightBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 254, 242, 128), // Yellow
            Color.fromARGB(255, 240, 150, 180), // Pink
          ],
        ),
      ),
    );
  }
}
