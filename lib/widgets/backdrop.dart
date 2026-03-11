import 'package:flutter/material.dart';

/// Backdrop provides a consistent background for all screens in the application.
/// It uses a linear gradient transitioning from blue to green.
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
            Color.fromARGB(255, 33, 222, 243),
            Color.fromARGB(255, 79, 252, 142),
          ],
        ),
      ),
    );
  }
}
