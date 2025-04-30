import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/billing_provider.dart';
import '../providers/product_catalog_provider.dart';

class ProductForm extends StatefulWidget {
  const ProductForm({super.key});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  double _gstRate = 5.0;
  bool _isQuickAdd = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text;
    final price = double.tryParse(_priceController.text) ?? 0;

    if (name.isEmpty || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid product details')),
      );
      return;
    }

    // Add to current bill
    Provider.of<BillingProvider>(context, listen: false)
        .addCustomProduct(name, price, _gstRate);

    // Also add to catalog if checkbox is checked
    if (_isQuickAdd) {
      Provider.of<ProductCatalogProvider>(context, listen: false)
          .addProduct(name, price, _gstRate);
    }

    _nameController.clear();
    _priceController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Add Product',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                      prefixText: '₹ ',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<double>(
                    value: _gstRate,
                    decoration: const InputDecoration(
                      labelText: 'GST Rate',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 5.0, child: Text('5% GST')),
                      DropdownMenuItem(value: 12.0, child: Text('12% GST')),
                      DropdownMenuItem(value: 18.0, child: Text('18% GST')),
                      DropdownMenuItem(value: 28.0, child: Text('28% GST')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _gstRate = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Bill'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _isQuickAdd,
                  onChanged: (value) {
                    setState(() {
                      _isQuickAdd = value ?? false;
                    });
                  },
                ),
                const Text('Also add to product catalog'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}