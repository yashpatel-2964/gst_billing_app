import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/billing_provider.dart';
import '../utils/gst_calculator.dart';
import '../models/product.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BillingProvider>(
      builder: (ctx, provider, _) {
        final products = provider.cartItems;

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Cart is empty',
                  style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add products to create an invoice',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: products.length + 1,
          itemBuilder: (ctx, i) {
            if (i == 0) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey[200],
                child: const Row(
                  children: [
                    Expanded(flex: 4, child: Text('Product', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                    Expanded(flex: 2, child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                    Expanded(flex: 2, child: Text('GST', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                    Expanded(flex: 2, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                    SizedBox(width: 40),
                  ],
                ),
              );
            } else {
              return _buildProductItem(context, products[i - 1]);
            }
          },
        );
      },
    );
  }

  //       return Column(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             color: Colors.grey[200],
  //             child: const Row(
  //               children: [
  //                 Expanded(
  //                   flex: 4,
  //                   child: Text(
  //                     'Product',
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 1,
  //                   child: Text(
  //                     'Qty',
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 2,
  //                   child: Text(
  //                     'Price',
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                     textAlign: TextAlign.right,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 2,
  //                   child: Text(
  //                     'GST',
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                     textAlign: TextAlign.right,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 2,
  //                   child: Text(
  //                     'Total',
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                     textAlign: TextAlign.right,
  //                   ),
  //                 ),
  //                 SizedBox(width: 40), // For the remove button
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: ListView.builder(
  //               itemCount: products.length,
  //               itemBuilder: (ctx, i) => _buildProductItem(context, products[i]),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildProductItem(BuildContext context, Product product) {
    final cgst = GSTCalculator.calculateCGST(product.price, product.gstRate);
    final sgst = GSTCalculator.calculateSGST(product.price, product.gstRate);
    final itemTotal = GSTCalculator.calculateItemTotal(
      product.price,
      product.gstRate,
      product.quantity,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Unit Price: ₹${product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: _buildQuantityControls(context, product),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '₹${(product.price * product.quantity).toStringAsFixed(2)}',
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${(cgst * product.quantity).toStringAsFixed(2)}'),
                  Text('₹${(sgst * product.quantity).toStringAsFixed(2)}'),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '₹${itemTotal.toStringAsFixed(2)}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                Provider.of<BillingProvider>(context, listen: false)
                    .removeFromCart(product.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (product.quantity > 1) {
              Provider.of<BillingProvider>(context, listen: false)
                  .updateQuantity(product.id, product.quantity - 1);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.remove, size: 16),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${product.quantity}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        InkWell(
          onTap: () {
            Provider.of<BillingProvider>(context, listen: false)
                .updateQuantity(product.id, product.quantity + 1);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.add, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}