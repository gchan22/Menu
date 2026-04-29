import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/service_providers.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/category_items_provider.dart';
import '../providers/description_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/restaurant.dart';
import '../screens/choice_menu.dart';

class MenuListTile extends ConsumerWidget {
  final Map<String, dynamic> menu;
  final bool isDeleting;

  const MenuListTile({
    super.key,
    required this.menu,
    required this.isDeleting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantInfo = menu['restaurantInfo'] ?? {};
    final name = restaurantInfo['name']?.toString().isNotEmpty == true 
        ? restaurantInfo['name'] 
        : 'Unnamed Restaurant';
    final slogan = restaurantInfo['slogan'] ?? '';

    return ListTile(
      title: Text(name),
      subtitle: Text(slogan),
      trailing: isDeleting 
          ? IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ChoiceMenuScreen(menuIdToDelete: menu['id']),
                  ),
                );
              },
            )
          : const Icon(Icons.arrow_forward),
      onTap: isDeleting 
          ? null 
          : () async {
        ref.read(databaseServiceProvider).currentMenuId = menu['id'];
        
        ref.invalidate(restaurantInfoProvider);
        ref.invalidate(menuProvider);
        ref.invalidate(categoryItemsProvider);
        ref.invalidate(descriptionProvider);
        ref.invalidate(cartProvider);

        // Await the new data to be fetched so the UI doesn't 
        // flash or mistakenly retain the previous menu's data.
        await ref.read(restaurantInfoProvider.future);
        await ref.read(menuProvider.future);
        await ref.read(categoryItemsProvider.future);
        await ref.read(descriptionProvider.future);
        await ref.read(cartProvider.future);

        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const RestaurantScreen(),
          ),
        );
      },
    );
  }
}