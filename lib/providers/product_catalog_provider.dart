import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/product.dart';
import '../utils/database_helper.dart';

class ProductCatalogProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Product> get products => _searchQuery.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;

  ProductCatalogProvider() {
    loadProducts();
  }

  // Load all products from database
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await _dbHelper.getProducts();
    _applySearch();

    _isLoading = false;
    notifyListeners();
  }

  // Add a new product to catalog
  Future<void> addProduct(String name, double price, double gstRate) async {
    final newProduct = Product(
      id: const Uuid().v4(),
      name: name,
      price: price,
      gstRate: gstRate,
    );

    await _dbHelper.insertProduct(newProduct);
    await loadProducts();
  }

  // Delete a product from catalog
  Future<void> deleteProduct(String id) async {
    await _dbHelper.deleteProduct(id);
    await loadProducts();
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }
}