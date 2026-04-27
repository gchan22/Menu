import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/success_header.dart';
import '../widgets/multi_menu_success_buttons.dart';

/// SuccessScreen is displayed after a successful account creation.
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SuccessHeader(),
                  const SizedBox(height: 40),
                  const MultiMenuSuccessButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
