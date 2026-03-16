import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_box.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/category_items_provider.dart';
import '../providers/description_provider.dart';
import '../providers/cart_provider.dart';
import 'restaurant.dart';
import 'success.dart';

class ChoiceMenuScreen extends ConsumerWidget {
  const ChoiceMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          // Reset all saved data as per prompt 74
                          ref.read(restaurantInfoProvider.notifier).reset();
                          ref.read(menuProvider.notifier).reset();
                          ref.read(categoryItemsProvider.notifier).reset();
                          ref.read(descriptionProvider.notifier).reset();
                          ref.read(cartProvider.notifier).clear();

                          // Go to Restaurant Screen
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const RestaurantScreen(),
                            ),
                          );
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
