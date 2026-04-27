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
          onPressed: () async {
            await ref.read(cartProvider.notifier).clear();
          },
        ),
        const SizedBox(width: 20),
        CustomButton(
          label: 'Pay',
          onPressed: () async {
            final asyncMenu = ref.read(menuProvider);
            final menuItems = asyncMenu.value ?? [];
            final category = menuItems.isNotEmpty ? menuItems[0].label : 'Menu';
            await ref.read(cartProvider.notifier).clear();
            
            if (!context.mounted) return;
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