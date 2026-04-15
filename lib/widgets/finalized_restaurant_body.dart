import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';
import '../screens/finalized_menu.dart';
import 'info_box.dart';
import 'custom_button.dart';

class FinalizedRestaurantBody extends ConsumerWidget {
  final String restaurantName;
  final String slogan;

  const FinalizedRestaurantBody({
    super.key,
    required this.restaurantName,
    required this.slogan,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(restaurantInfoProvider);
    final menuItems = ref.watch(menuProvider);

    // Displays the restaurant name in a styled container
    final restaurantNameBox = InfoBox(
      text: info.name.isNotEmpty ? info.name : restaurantName,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    // Displays the slogan in a styled container
    final sloganBox = InfoBox(
      text: info.slogan.isNotEmpty ? info.slogan : slogan,
      fontSize: 18,
      fontStyle: FontStyle.italic,
    );

    // Button to proceed to the finalized menu viewing screen
    final startEatingButton = CustomButton(
      label: 'Start Eating',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinalizedMenuScreen(
              menuItems: menuItems,
            ),
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          restaurantNameBox,
          const SizedBox(height: 20),
          sloganBox,
          const SizedBox(height: 40),
          startEatingButton,
        ],
      ),
    );
  }
}