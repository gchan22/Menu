import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../providers/menu_provider.dart';
import '../screens/thank_you.dart';
import 'custom_button.dart';

class CartButtons extends ConsumerWidget {
  const CartButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          label: 'Clear Cart',
          onPressed: () {
            ref.read(cartProvider.notifier).clear();
          },
        ),
        const SizedBox(width: 20),
        CustomButton(
          label: 'Pay',
          onPressed: () {
            final menuItems = ref.read(menuProvider);
            final category = menuItems.isNotEmpty ? menuItems[0].label : 'Menu';
            ref.read(cartProvider.notifier).clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ThankYouScreen(
                  category: category,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}