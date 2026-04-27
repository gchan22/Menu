import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant_info.dart';
import 'service_providers.dart';

/// Notifier class for managing restaurant-level information.
class RestaurantInfoNotifier extends AsyncNotifier<RestaurantInfoModel> {
  /// Loads restaurant info from Firestore when the provider is initialized.
  @override
  Future<RestaurantInfoModel> build() async {
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      // No user logged in, return default empty state
      return RestaurantInfoModel(name: '', slogan: '');
    }

    final db = ref.read(databaseServiceProvider);
    final userData = await db.fetchUserData(user.uid);

    if (userData != null && userData.containsKey('restaurantInfo')) {
      final restaurantData = userData['restaurantInfo'] as Map<String, dynamic>?;
      if (restaurantData != null) {
        return RestaurantInfoModel.fromMap(restaurantData);
      }
    }

    // Initial state or no data found in Firestore
    return RestaurantInfoModel(name: '', slogan: '');
  }

  /// Updates the restaurant's name and slogan and saves to Firestore.
  Future<void> updateInfo(String name, String slogan) async {
    // Optimistically update the state so the UI is responsive
    state = AsyncData(RestaurantInfoModel(name: name, slogan: slogan));

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final db = ref.read(databaseServiceProvider);
    await db.saveField(user.uid, 'restaurantInfo', state.value!.toMap());
  }

  /// Resets the restaurant information to its initial empty state and saves to Firestore.
  Future<void> reset() async {
    state = AsyncData(RestaurantInfoModel(name: '', slogan: ''));

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final db = ref.read(databaseServiceProvider);
    await db.saveField(user.uid, 'restaurantInfo', state.value!.toMap());
  }
}

/// Provider to access and manage restaurant information across the application.
final restaurantInfoProvider =
    AsyncNotifierProvider<RestaurantInfoNotifier, RestaurantInfoModel>(() {
  return RestaurantInfoNotifier();
});
