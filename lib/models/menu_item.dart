class MenuItemModel {
  final int? id;
  final String name;
  final double price;

  MenuItemModel({this.id, required this.name, required this.price});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price};
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> m) {
    return MenuItemModel(
      id: m['id'] as int?,
      name: m['name'] as String,
      price: (m['price'] as num).toDouble(),
    );
  }
}
