import 'package:flutter/material.dart';

class SliderButtons extends StatelessWidget {
  final List<String> categories = [
    'Electronics',
    'Fashion',
    'Home',
    'Books',
    'Sports',
    'Toys'
  ];

  SliderButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Set a fixed height for the container
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((title) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Add your button's functionality here
                  print('Selected category: $title');
                },
                child: Text(title),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
