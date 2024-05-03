import 'package:flutter/material.dart';

class BottomNavigationBarWrapper extends StatelessWidget {
  final void Function(int) onItemTapped; // Function to handle item tap

  const BottomNavigationBarWrapper({
    Key? key,
    required this.onItemTapped,
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

