import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_button.dart';
import '../screens/finalized_items.dart';
import '../screens/finalized_restaurant.dart';
import '../providers/restaurant_provider.dart';
import '../providers/category_items_provider.dart';

/// A reusable widget containing the action buttons for the thank you screen.
class ThankYouActionButtons extends ConsumerWidget {
  final String category;

  const ThankYouActionButtons({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          label: 'Continue Shopping',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FinalizedItemsScreen(
                  category: category,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        CustomButton(
          label: 'Finished Shopping',
          onPressed: () {
            // Clear all notes from all items in all categories
            final allCategoryItems = ref.read(categoryItemsProvider);
            for (final categoryKey in allCategoryItems.keys) {
              final items = allCategoryItems[categoryKey] ?? [];
              final updatedItems = items.map((item) {
                return item.copyWith(note: ''); // Clear the note
              }).toList();
              ref.read(categoryItemsProvider.notifier).setCategoryItems(categoryKey, updatedItems);
            }

            final info = ref.read(restaurantInfoProvider);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => FinalizedRestaurantScreen(
                  restaurantName: info.name,
                  slogan: info.slogan,
                ),
              ),
              (route) => false,
            );
          },
        ),
      ],
    );
  }
}