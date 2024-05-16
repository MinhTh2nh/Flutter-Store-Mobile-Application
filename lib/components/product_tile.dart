// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String product_name;
  final String product_price;
  final String product_thumbnail;
  final int total_stock;
  final double average_rating;
  final void Function()? onPressed;

  const ProductTile({
    super.key,
    required this.product_name,
    required this.product_price,
    required this.product_thumbnail,
    required this.total_stock,
    required this.onPressed,
    required this.average_rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // Add margin bottom
      child: Material(
        elevation: 3, // Add elevation for shadow effect
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product_thumbnail,
              width: double.infinity, // Take whole width
              height: MediaQuery.of(context).size.height * 0.15,
              fit: BoxFit.contain,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                // You can return an error image or a placeholder here
                return Image.asset(
                  'lib/images/blank.png',
                  fit: BoxFit.contain,
                );
              },
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8), // Add padding
                  child: Text(
                    product_name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8), // Add padding
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8), // Add padding
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        average_rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
