import 'package:flutter/material.dart';
import '../../pages/home/home.dart';
import '../../pages/products.dart';
import '../../pages/settings/settings.dart';

class BottomNavigationBarWrapper extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped; // Explicitly specify the type

  const BottomNavigationBarWrapper({super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.teal.shade200,
        onTap: onItemTapped,
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
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const Products();
      case 2:
        return const Settings();
      default:
        return Container(); // Placeholder, you can return any default widget here
    }
  }
}
