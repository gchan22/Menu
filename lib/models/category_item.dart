/// Represents a specific food item within a category.
class CategoryItemModel {
  /// The name of the food item.
  final String name;
  /// The price of the food item.
  final String price;

  CategoryItemModel({required this.name, required this.price});

  /// Converts the model into a map for storage or transmission.
  /// returns a map assigning name and price
  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
      };

  /// Creates a model instance from a map.
  /// Packages the object to save data after closing app
  factory CategoryItemModel.fromMap(Map<String, dynamic> map) => CategoryItemModel(
        name: map['name'] as String,
        price: map['price'] as String,
      );
}
