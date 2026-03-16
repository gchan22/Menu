import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant_info.dart';

/// Notifier class for managing restaurant-level information.
class RestaurantInfoNotifier extends Notifier<RestaurantInfoModel> {
  @override
  RestaurantInfoModel build() {
    // Initial state: empty restaurant name and slogan
    return RestaurantInfoModel(name: '', slogan: '');
  }

  /// Updates the restaurant's name and slogan.
  void updateInfo(String name, String slogan) {
    state = RestaurantInfoModel(name: name, slogan: slogan);
  }
}

/// Provider to access and manage restaurant information across the application.
final restaurantInfoProvider = NotifierProvider<RestaurantInfoNotifier, RestaurantInfoModel>(() {
  return RestaurantInfoNotifier();
});
