import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant_info.dart';
import 'shared_preferences_provider.dart';

/// Notifier class for managing restaurant-level information.
class RestaurantInfoNotifier extends Notifier<RestaurantInfoModel> {
  static const _key = 'restaurant_info';

  /// load saved preferences
  @override
  RestaurantInfoModel build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final data = prefs.getString(_key);
    if (data != null) {
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(data);
        return RestaurantInfoModel.fromMap(jsonMap);
      } catch (e) {
        // Fallback
      }
    }
    // Initial state: empty restaurant name and slogan
    return RestaurantInfoModel(name: '', slogan: '');
  }

  /// Save current state to preferences
  void _save() {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(_key, jsonEncode(state.toMap()));
  }

  /// Updates the restaurant's name and slogan.
  void updateInfo(String name, String slogan) {
    state = RestaurantInfoModel(name: name, slogan: slogan);
    _save();
  }
}

/// Provider to access and manage restaurant information across the application.
final restaurantInfoProvider = NotifierProvider<RestaurantInfoNotifier, RestaurantInfoModel>(() {
  return RestaurantInfoNotifier();
});
