class CategoryItemModel {
  final String name;
  final String price;

  CategoryItemModel({required this.name, required this.price});

  Map<String, String> toMap() => {
        'name': name,
        'price': price,
      };

  factory CategoryItemModel.fromMap(Map<String, String> map) => CategoryItemModel(
        name: map['name']!,
        price: map['price']!,
      );
}
