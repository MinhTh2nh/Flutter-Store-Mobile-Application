// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final String product_name;
  final String product_price;
  final String product_thumbnail;
  final int total_stock;
  final void Function()? onPressed;

  const ProductTile({
    super.key,
    required this.product_name,
    required this.product_price,
    required this.product_thumbnail,
    required this.total_stock,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // Add margin bottom
      child: Material(
        elevation: 3, // Add elevation for shadow effect
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5), // Adjust padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product_thumbnail,
                width: double.infinity, // Take whole width
                height: 150,
                // fit: BoxFit.cover,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8), // Add padding
                child: Text(
                  product_name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8), // Add padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$$product_price',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Available: $total_stock',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
