/// Simple data class to hold restaurant identity information.
class RestaurantInfoModel {
  /// The display name of the restaurant.
  final String name;
  /// The restaurant's marketing slogan.
  final String slogan;

  RestaurantInfoModel({required this.name, required this.slogan});

  Map<String, dynamic> toMap() => {
        'name': name,
        'slogan': slogan,
      };

  factory RestaurantInfoModel.fromMap(Map<String, dynamic> map) => RestaurantInfoModel(
        name: map['name'] as String? ?? '',
        slogan: map['slogan'] as String? ?? '',
      );
}
