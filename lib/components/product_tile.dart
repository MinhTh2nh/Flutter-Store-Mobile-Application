import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              offset: Offset(0, 10),
              blurRadius: 10,
              spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(
            imagePath,
            height: 100,
            // fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  itemName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '\$$itemPrice',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
