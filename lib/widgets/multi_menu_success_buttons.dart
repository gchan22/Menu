import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/service_providers.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/category_items_provider.dart';
import '../providers/description_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/multi_menu.dart';
import '../screens/restaurant.dart';
import '../screens/choice_menu.dart';
import 'custom_button.dart';

class MultiMenuSuccessButtons extends ConsumerWidget {
  const MultiMenuSuccessButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CustomButton(
          label: 'Continue Edit',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MultiMenuScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        CustomButton(
          label: 'Create Another Menu',
          onPressed: () async {
            ref.read(databaseServiceProvider).currentMenuId = null;

            // Explicitly force all providers to wipe their data to blank states,
            // preventing the previous menu's data from ghosting into the UI.
            await ref.read(restaurantInfoProvider.notifier).reset();
            await ref.read(menuProvider.notifier).reset();
            await ref.read(categoryItemsProvider.notifier).reset();
            await ref.read(descriptionProvider.notifier).reset();
            await ref.read(cartProvider.notifier).clear();

            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RestaurantScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        CustomButton(
          label: 'New Menu (Reset Current)',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ChoiceMenuScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}