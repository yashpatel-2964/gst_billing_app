class Product {
  final String id;
  final String name;
  final double price;
  final double gstRate;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.gstRate,
    this.quantity = 1,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? gstRate,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      gstRate: gstRate ?? this.gstRate,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'gstRate': gstRate,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      gstRate: map['gstRate'],
      quantity: map['quantity'] ?? 1,
    );
  }
}