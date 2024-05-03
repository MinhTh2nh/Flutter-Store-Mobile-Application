import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final int totalStock;
  final void Function()? onPressed;

  const ProductTile({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.totalStock,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10), // Add margin bottom
      child: Material(
        elevation: 3, // Add elevation for shadow effect
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5), // Adjust padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10), // Add padding
                child: SizedBox(
                  height: 0.27 * (MediaQuery.of(context).size.width), // Set height to 30% of the width of the screen
                  child: Image.network(
                    imagePath,
                    width: double.infinity, // Take whole width
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8), // Add padding
                child: Text(
                  itemName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8), // Add padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$$itemPrice',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Available: $totalStock',
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
