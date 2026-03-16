import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_item.dart';
import '../providers/cart_provider.dart';

/// A UI row for an item in the cart, including its price and a remove button.
class CartItemRow extends ConsumerWidget {
  final CategoryItemModel item;

  const CartItemRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.shopping_cart, size: 24, color: Colors.blueAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.price,
            style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          // Button to remove the item from the cart state
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () {
              ref.read(cartProvider.notifier).removeItem(item);
            },
          ),
        ],
      ),
    );
  }
}
