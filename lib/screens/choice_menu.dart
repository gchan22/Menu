import 'package:flutter/material.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_box.dart';
import 'success.dart';

class ChoiceMenuScreen extends StatelessWidget {
  const ChoiceMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoBox(
                    text: 'Are you sure you want to create a new menu',
                    fontSize: 18,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        label: 'Yes',
                        onPressed: () {
                          // Currently does nothing as per prompt 68
                        },
                      ),
                      const SizedBox(width: 20),
                      CustomButton(
                        label: 'No',
                        onPressed: () {
                          // Go back to the Success Screen
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const SuccessScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
