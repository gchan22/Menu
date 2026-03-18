import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import 'finalized_items.dart';
import 'finalized_restaurant.dart';
import '../providers/restaurant_provider.dart';
import '../providers/category_items_provider.dart';

/// ThankYouScreen displays a gratitude message after payment and offers navigation options.
class ThankYouScreen extends ConsumerWidget {
  final String category;

  const ThankYouScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(restaurantInfoProvider);

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
                  const Text(
                    'Thank You',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
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
