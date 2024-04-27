import 'package:flutter/widgets.dart';
import 'package:food_mobile_app/pages/home/home.dart';
import 'package:food_mobile_app/pages/products.dart';
import 'package:food_mobile_app/pages/settings/settings.dart';
import '../components/bottom_navigation_bar/bottom_navigation_bar_wrapper.dart';

final Map<String, WidgetBuilder> settingsRoutes = {
  '/settings': (context) => BottomNavigationBarWrapper(selectedIndex: 2, onItemTapped: (index) {
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
