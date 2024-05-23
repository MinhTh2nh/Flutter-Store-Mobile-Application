import 'package:flutter/widgets.dart';
import '../components/bottom_navigation_bar/bottom_navigation_bar_wrapper.dart';

final Map<String, WidgetBuilder> productsRoutes = {
  '/products': (context) => BottomNavigationBarWrapper(selectedIndex: 1, onItemTapped: (index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/products');
        break;
      case 2:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }),
};
