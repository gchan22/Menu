/// Represents a specific food item within a category.
class CategoryItemModel {
  /// The name of the food item.
  final String name;
  /// The price of the food item.
  final String price;

  CategoryItemModel({required this.name, required this.price});

  /// Converts the model into a map for storage or transmission.
  Map<String, String> toMap() => {
        'name': name,
        'price': price,
      };

  /// Creates a model instance from a map.
  factory CategoryItemModel.fromMap(Map<String, String> map) => CategoryItemModel(
        name: map['name']!,
        price: map['price']!,
      );
}
