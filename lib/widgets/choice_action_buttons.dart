import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_button.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/category_items_provider.dart';
import '../providers/description_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/restaurant.dart';
import '../screens/success.dart';

/// A reusable widget containing the action buttons to create a new menu or cancel.
class ChoiceActionButtons extends ConsumerWidget {
  const ChoiceActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          label: 'Yes',
          onPressed: () async {
            // Reset all saved data as per prompt 74
            // This now also clears the data in Firestore
            await ref.read(restaurantInfoProvider.notifier).reset();
            await ref.read(menuProvider.notifier).reset();
            await ref.read(categoryItemsProvider.notifier).reset();
            await ref.read(descriptionProvider.notifier).reset();
            await ref.read(cartProvider.notifier).clear();

            if (!context.mounted) return;
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
    );
  }
}