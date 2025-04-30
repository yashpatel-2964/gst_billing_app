import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/invoice.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'gst_billing.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT,
        price REAL,
        gstRate REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE invoices(
        id TEXT PRIMARY KEY,
        dateTime TEXT,
        customerName TEXT,
        customerPhone TEXT,
        total REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE invoice_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoiceId TEXT,
        productId TEXT,
        quantity INTEGER,
        price REAL,
        gstRate REAL,
        FOREIGN KEY (invoiceId) REFERENCES invoices (id),
        FOREIGN KEY (productId) REFERENCES products (id)
      )
    ''');
  }

  // Product operations
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Invoice operations
  Future<String> saveInvoice(Invoice invoice) async {
    final db = await database;
    await db.insert(
      'invoices',
      invoice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Save invoice items
    for (var product in invoice.products) {
      await db.insert(
        'invoice_items',
        {
          'invoiceId': invoice.id,
          'productId': product.id,
          'quantity': product.quantity,
          'price': product.price,
          'gstRate': product.gstRate,
        },
      );
    }

    return invoice.id;
  }

  Future<List<Invoice>> getInvoices() async {
    final db = await database;
    final List<Map<String, dynamic>> invoiceMaps = await db.query('invoices', orderBy: 'dateTime DESC');

    List<Invoice> invoices = [];

    for (var invoiceMap in invoiceMaps) {
      final String invoiceId = invoiceMap['id'];

      // Get invoice items
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'invoice_items',
        where: 'invoiceId = ?',
        whereArgs: [invoiceId],
      );

      // Convert to products
      final List<Product> products = [];
      for (var itemMap in itemMaps) {
        final productId = itemMap['productId'];
        final List<Map<String, dynamic>> productMaps = await db.query(
          'products',
          where: 'id = ?',
          whereArgs: [productId],
        );

        if (productMaps.isNotEmpty) {
          Product product = Product.fromMap(productMaps.first);
          product = product.copyWith(
            quantity: itemMap['quantity'],
            price: itemMap['price'],
            gstRate: itemMap['gstRate'],
          );
          products.add(product);
        }
      }

      invoices.add(Invoice.fromMap(invoiceMap, products));
    }

    return invoices;
  }

  Future<Invoice?> getInvoice(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> invoiceMaps = await db.query(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (invoiceMaps.isEmpty) {
      return null;
    }

    // Get invoice items
    final List<Map<String, dynamic>> itemMaps = await db.query(
      'invoice_items',
      where: 'invoiceId = ?',
      whereArgs: [id],
    );

    // Convert to products
    final List<Product> products = [];
    for (var itemMap in itemMaps) {
      final productId = itemMap['productId'];
      final List<Map<String, dynamic>> productMaps = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [productId],
      );

      if (productMaps.isNotEmpty) {
        Product product = Product.fromMap(productMaps.first);
        product = product.copyWith(
          quantity: itemMap['quantity'],
          price: itemMap['price'],
          gstRate: itemMap['gstRate'],
        );
        products.add(product);
      }
    }

    return Invoice.fromMap(invoiceMaps.first, products);
  }

  Future<void> deleteInvoice(String id) async {
    final db = await database;
    await db.delete(
      'invoice_items',
      where: 'invoiceId = ?',
      whereArgs: [id],
    );
    await db.delete(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}