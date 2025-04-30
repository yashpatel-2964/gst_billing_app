import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/billing_provider.dart';
import '../widgets/product_form.dart';
import '../widgets/product_list.dart';
import '../widgets/summary_card.dart';
import 'invoice_screen.dart';
import 'product_catalog_screen.dart';
import 'transaction_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    super.dispose();
  }

  void _generateInvoice(BuildContext context) async {
    final provider = Provider.of<BillingProvider>(context, listen: false);

    if (provider.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add products to the cart first')),
      );
      return;
    }

    try {
      final invoiceId = await provider.generateInvoice(
        customerName: _customerNameController.text.isNotEmpty
            ? _customerNameController.text
            : 'Guest Customer',
        customerPhone: _customerPhoneController.text,
      );

      if (!mounted) return;

      // Clear the form
      _customerNameController.clear();
      _customerPhoneController.clear();

      // Navigate to invoice screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => InvoiceScreen(invoiceId: invoiceId),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TATA Retail - GST Billing'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Transaction History',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const TransactionHistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Product Catalog',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const ProductCatalogScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Customer Information Card
          Card(
            margin: const EdgeInsets.all(8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _customerPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),

          // Product Form
          const ProductForm(),

          // Billing Summary
          const SummaryCard(),

          // Product List
          const Expanded(
            child: ProductList(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.indigo,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.clear_all, color: Colors.white),
              label: const Text('Clear All', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Provider.of<BillingProvider>(context, listen: false).clearCart();
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt),
              label: const Text('Generate Invoice'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.indigo,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () => _generateInvoice(context),
            ),
          ],
        ),
      ),
    );
  }
}