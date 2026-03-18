/// Represents a specific food item within a category.
class CategoryItemModel {
  /// The name of the food item.
  final String name;
  /// The price of the food item.
  final String price;
  /// Optional note for the item.
  final String? note;

  CategoryItemModel({required this.name, required this.price, this.note});

  /// Converts the model into a map for storage or transmission.
  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'note': note,
      };

  /// Creates a model instance from a map.
  factory CategoryItemModel.fromMap(Map<String, dynamic> map) => CategoryItemModel(
        name: map['name'] as String,
        price: map['price'] as String,
        note: map['note'] as String?,
      );
}
