import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/custom_button.dart';
import 'finalized_items.dart';
import 'finalized_restaurant.dart';
import '../providers/restaurant_provider.dart';
import '../models/category_item.dart';

/// ThankYouScreen displays a gratitude message after payment and offers navigation options.
class ThankYouScreen extends ConsumerWidget {
  final String category;
  final List<CategoryItemModel> items;

  const ThankYouScreen({
    super.key,
    required this.category,
    required this.items,
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
                                items: items,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      CustomButton(
                        label: 'Finished Shopping',
                        onPressed: () {
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
