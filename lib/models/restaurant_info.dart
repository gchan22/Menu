/// Simple data class to hold restaurant identity information.
class RestaurantInfoModel {
  /// The display name of the restaurant.
  final String name;
  /// The restaurant's marketing slogan.
  final String slogan;

  RestaurantInfoModel({required this.name, required this.slogan});

  /// Converts the model into a map for storage or transmission.
  /// returns a map assigning name and slogan
  Map<String, dynamic> toMap() => {
        'name': name,
        'slogan': slogan,
      };

  /// Creates a model instance from a map.
  /// Packages the object to save data after closing app
  factory RestaurantInfoModel.fromMap(Map<String, dynamic> map) => RestaurantInfoModel(
        name: map['name'] as String? ?? '',
        slogan: map['slogan'] as String? ?? '',
      );
}
