import 'package:flutter/material.dart';

class BottomNavigationBarWrapper extends StatelessWidget {
  final void Function(int)? onItemTapped; // Make it nullable by adding '?'

  const BottomNavigationBarWrapper({
    Key? key,
    this.onItemTapped, // Update here as well
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onItemTapped,
      selectedItemColor: Colors.teal.shade200,
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Product',
          icon: Icon(Icons.shopping_bag),
        ),
        BottomNavigationBarItem(
          label: 'Setting',
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }
}

