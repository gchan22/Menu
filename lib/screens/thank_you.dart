import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/thank_you_header.dart';
import '../widgets/thank_you_action_buttons.dart';

/// ThankYouScreen displays a gratitude message after payment and offers navigation options.
class ThankYouScreen extends StatelessWidget {
  final String category;

  const ThankYouScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ThankYouHeader(),
                  const SizedBox(height: 40),
                  ThankYouActionButtons(category: category),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
