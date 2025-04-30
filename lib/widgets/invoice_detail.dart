import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/invoice.dart';
import '../utils/gst_calculator.dart';

class InvoiceDetail extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetail({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      // Header
      Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TATA Retail Solutions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Invoice #${invoice.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text('Date: ${dateFormat.format(invoice.dateTime)}'),
            const SizedBox(height: 8),
            Text('Customer: ${invoice.customerName}'),
            if (invoice.customerPhone.isNotEmpty)
              Text('Phone: ${invoice.customerPhone}'),
          ],
        ),
      ),
    ),

    const SizedBox(height: 16),

    // Products Table
    Card(
    elevation: 2,
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Text(
    'Items',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 8),
    const Divider(),
    // Table Header
    const Row(
    children: [
    Expanded(
    flex: 4,
    child: Text(
    'Product',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    ),
      Expanded(
        flex: 1,
        child: Text(
          'Qty',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(
          'Price',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(
          'GST',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(
          'Total',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
      ),
    ],
    ),
      const Divider(),
      // Table Rows
      ...invoice.products.map((product) {
        final cgst = GSTCalculator.calculateCGST(product.price, product.gstRate);
        final sgst = GSTCalculator.calculateSGST(product.price, product.gstRate);
        final itemTotal = GSTCalculator.calculateItemTotal(
          product.price,
          product.gstRate,
          product.quantity,
        );

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(product.name),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${product.quantity}',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '₹${product.price.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${product.gstRate.toStringAsFixed(0)}%',
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '₹${itemTotal.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const Divider(),
          ],
        );
      }).toList(),
    ],
    ),
    ),
    ),

        const SizedBox(height: 16),

        // Summary
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text('₹${invoice.subtotal.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('CGST'),
                    Text('₹${invoice.totalCGST.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('SGST'),
                    Text('₹${invoice.totalSGST.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '₹${invoice.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}