import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_button.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/category_items_provider.dart';
import '../providers/service_providers.dart';
import '../providers/description_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/restaurant.dart';
import '../screens/success.dart';
import '../screens/multi_menu.dart';

/// A reusable widget containing the action buttons to create a new menu or cancel.
class ChoiceActionButtons extends ConsumerWidget {
  /// Specific menu ID to be deleted.
  final String? menuIdToDelete;

  const ChoiceActionButtons({super.key, this.menuIdToDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          label: 'Yes',
          onPressed: () async {
            if (menuIdToDelete != null) {
              final user = ref.read(authStateProvider).value;
              if (user != null) {
                await ref.read(databaseServiceProvider).deleteMenu(user.uid, menuIdToDelete!);
              }
            } else {
              // Reset all saved data as per prompt 74
              // This now also clears the data in Firestore
              await ref.read(restaurantInfoProvider.notifier).reset();
              await ref.read(menuProvider.notifier).reset();
              await ref.read(categoryItemsProvider.notifier).reset();
              await ref.read(descriptionProvider.notifier).reset();
              await ref.read(cartProvider.notifier).clear();
            }

            if (!context.mounted) return;
            
            if (menuIdToDelete != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MultiMenuScreen(isDeleting: true),
                ),
              );
            } else {
              // Go to Restaurant Screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const RestaurantScreen(),
                ),
              );
            }
          },
        ),
        const SizedBox(width: 20),
        CustomButton(
          label: 'No',
          onPressed: () {
            if (menuIdToDelete != null) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MultiMenuScreen(isDeleting: true),
                ),
              );
            } else {
              // Go back to the Success Screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SuccessScreen(),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}