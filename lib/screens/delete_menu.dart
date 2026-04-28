import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/service_providers.dart';

class DeleteMenuScreen extends ConsumerStatefulWidget {
  const DeleteMenuScreen({super.key});

  @override
  ConsumerState<DeleteMenuScreen> createState() => _DeleteMenuScreenState();
}

class _DeleteMenuScreenState extends ConsumerState<DeleteMenuScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Menus'),
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
                  return const Center(child: Text('No menus available to delete.'));
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Menu'),
                              content: Text('Are you sure you want to delete "$name"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await ref.read(databaseServiceProvider).deleteMenu(user.uid, menu['id']);
                            // Refresh the state to update the list view
                            setState(() {});
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}