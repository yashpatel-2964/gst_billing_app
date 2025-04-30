import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../models/invoice.dart';
import '../utils/database_helper.dart';

class BillingProvider extends ChangeNotifier {
  final List<Product> _cartItems = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Invoice> _invoices = [];
  bool _isLoading = false;

  List<Product> get cartItems => _cartItems;
  List<Invoice> get invoices => _invoices;
  bool get isLoading => _isLoading;

  double get subtotal => _cartItems.fold(
      0, (sum, product) => sum + (product.price * product.quantity));

  double get totalCGST => _cartItems.fold(
      0,
          (sum, product) =>
      sum +
          ((product.price * product.gstRate / 100) / 2 * product.quantity));

  double get totalSGST => totalCGST;

  double get total => subtotal + totalCGST + totalSGST;

  // Add a product to the cart
  void addToCart(Product product) {
    final existingIndex = _cartItems.indexWhere((item) => item.id == product.id);

    if (existingIndex >= 0) {
      // Update quantity if the product already exists
      final existingItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // Add new product
      _cartItems.add(product);
    }
    notifyListeners();
  }

  // Add a custom product to the cart
  void addCustomProduct(String name, double price, double gstRate) {
    final newProduct = Product(
      id: const Uuid().v4(),
      name: name,
      price: price,
      gstRate: gstRate,
    );
    _cartItems.add(newProduct);
    notifyListeners();
  }

  // Update quantity of a product in cart
  void updateQuantity(String productId, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  // Remove a product from cart
  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  // Clear the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Generate invoice and save to database
  Future<String> generateInvoice({
    String customerName = 'Guest Customer',
    String customerPhone = '',
  }) async {
    if (_cartItems.isEmpty) {
      throw Exception('Cart is empty');
    }

    final invoice = Invoice(
      products: List.from(_cartItems),
      customerName: customerName,
      customerPhone: customerPhone,
    );

    final invoiceId = await _dbHelper.saveInvoice(invoice);
    await loadInvoices();
    clearCart();
    return invoiceId;
  }

  // Load all invoices from database
  Future<void> loadInvoices() async {
    _isLoading = true;
    notifyListeners();

    _invoices = await _dbHelper.getInvoices();

    _isLoading = false;
    notifyListeners();
  }

  // Get a specific invoice by ID
  Future<Invoice?> getInvoice(String id) async {
    return await _dbHelper.getInvoice(id);
  }

  // Delete an invoice
  Future<void> deleteInvoice(String id) async {
    await _dbHelper.deleteInvoice(id);
    await loadInvoices();
  }
}