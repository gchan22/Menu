import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/backdrop.dart';
import '../widgets/cart_item_row.dart';
import '../widgets/custom_button.dart';
import '../providers/cart_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/category_items_provider.dart';
import 'thank_you.dart';

/// CartScreen displays the list of items the user has added to their virtual cart.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalCost = ref.watch(cartTotalProvider);

    // A styled header box for the cart screen
    final cartTitle = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Cart',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    String formatCurrency(double value) {
      String parts = value.toStringAsFixed(2);
      List<String> split = parts.split('.');
      String integerPart = split[0];
      String decimalPart = split[1];

      RegExp reg = RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))");
      String formattedInteger = integerPart.replaceAllMapped(reg, (Match m) => "${m[1]},");

      return "\$$formattedInteger.$decimalPart";
    }

    final tax = totalCost * 0.08875;
    final overallTotal = totalCost + tax;

    // Total cost rows displayed at the bottom of the list
    final summaryTable = Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Cost:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                formatCurrency(totalCost),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tax (8.875%):',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                formatCurrency(tax),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                formatCurrency(overallTotal),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Backdrop(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  cartTitle,
                  const SizedBox(height: 20),
                  // Render a row for each item in the cart
                  ...cartItems.map((item) {
                    return CartItemRow(item: item);
                  }),
                  if (cartItems.isNotEmpty) ...[
                    summaryTable,
                    const SizedBox(height: 20),
                    Row(
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
                            final items = ref.read(categoryItemsProvider)[category] ?? [];
                            ref.read(cartProvider.notifier).clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ThankYouScreen(
                                  category: category,
                                  items: items,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                  if (cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text('Your cart is empty', style: TextStyle(fontSize: 18)),
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
