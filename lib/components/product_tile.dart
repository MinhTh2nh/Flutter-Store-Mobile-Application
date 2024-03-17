import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final void Function()? onPressed;

  const ProductTile({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1, // Adjust aspect ratio as needed
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              itemName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('\$$itemPrice'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
