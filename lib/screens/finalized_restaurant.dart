import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/finalized_restaurant_body.dart';
import '../widgets/sign_in_nav_button.dart';
import '../widgets/theme_selection_button.dart';

/// FinalizedRestaurantScreen displays a read-only preview of the restaurant name and slogan.
class FinalizedRestaurantScreen extends ConsumerWidget {
  final String restaurantName;
  final String slogan;

  const FinalizedRestaurantScreen({
    super.key,
    required this.restaurantName,
    required this.slogan,
  });

  /// The screen layout
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          const Backdrop(),
          FinalizedRestaurantBody(
            restaurantName: restaurantName,
            slogan: slogan,
          ),
          const Positioned(
            top: 40,
            left: 16,
            child: SignInNavButton(),
          ),
          const Positioned(
            top: 40,
            right: 16,
            child: ThemeSelectionButton(),
          ),
        ],
      ),
    );
  }
}
