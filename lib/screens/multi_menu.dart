import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/service_providers.dart';
import '../providers/restaurant_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/category_items_provider.dart';
import '../providers/description_provider.dart';
import '../providers/cart_provider.dart';
import 'restaurant.dart';
import 'choice_menu.dart';

class MultiMenuScreen extends ConsumerWidget {
  final bool isDeleting;

  const MultiMenuScreen({super.key, this.isDeleting = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text(isDeleting ? 'Delete a Menu' : 'Your Menus'),
      ),
      body: user == null
          ? const Center(child: Text('Please sign in to view your menus.'))
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: ref.read(databaseServiceProvider).fetchUserMenus(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading menus.'));
                }

                final menus = snapshot.data ?? [];

                if (menus.isEmpty) {
                  return const Center(child: Text('No menus created yet.'));
                }

                return ListView.builder(
                  itemCount: menus.length,
                  itemBuilder: (context, index) {
                    final menu = menus[index];
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
                  },
                );
              },
            ),
    );
  }
}