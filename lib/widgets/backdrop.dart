import 'package:flutter/material.dart';

/// Backdrop provides a consistent background for all screens in the application.
/// It uses a linear gradient transitioning from light blue to green.
class Backdrop extends StatelessWidget {
  const Backdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 173, 216, 230), // Light Blue
            Color.fromARGB(255, 144, 238, 144), // Green
          ],
        ),
      ),
    );
  }
}
