import 'package:uuid/uuid.dart';
import 'product.dart';

class Invoice {
  final String id;
  final List<Product> products;
  final DateTime dateTime;
  final String customerName;
  final String customerPhone;

  Invoice({
    String? id,
    required this.products,
    DateTime? dateTime,
    this.customerName = 'Guest Customer',
    this.customerPhone = '',
  }) :
        id = id ?? const Uuid().v4(),
        dateTime = dateTime ?? DateTime.now();

  double get subtotal => products.fold(
      0, (sum, product) => sum + (product.price * product.quantity));

  double get totalCGST => products.fold(
      0,
          (sum, product) =>
      sum +
          ((product.price * product.gstRate / 100) / 2 * product.quantity));

  double get totalSGST => totalCGST;

  double get total => subtotal + totalCGST + totalSGST;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'customerName': customerName,
      'customerPhone': customerPhone,
      'total': total,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map, List<Product> products) {
    return Invoice(
      id: map['id'],
      products: products,
      dateTime: DateTime.parse(map['dateTime']),
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
    );
  }
}
