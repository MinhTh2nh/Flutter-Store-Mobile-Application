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

  static double _roundRating(double rating) {
    double clampedRating = rating.clamp(0.0, 5.0);
    return (clampedRating * 2).round() / 2.0;
  }

  @override
  Widget build(BuildContext context) {
    double roundedRating = _roundRating(average_rating);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(bottom: 10), // Add margin bottom
      child: Material(
        elevation: 3, // Add elevation for shadow effect
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.all(5), // Add padding
              child:  Image.network(
                product_thumbnail,
                width: double.infinity, // Take whole width
                height: MediaQuery.of(context).size.height * 0.14,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // You can return an error image or a placeholder here
                  return Image.asset(
                    'lib/images/blank.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
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
                  padding: const EdgeInsets.all(4), // Add padding
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        roundedRating.toStringAsFixed(1),
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
