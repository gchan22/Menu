import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/service_providers.dart';
import '../widgets/menu_list_tile.dart';

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
                    return MenuListTile(
                      menu: menus[index],
                      isDeleting: isDeleting,
                    );
                  },
                );
              },
            ),
    );
  }
}