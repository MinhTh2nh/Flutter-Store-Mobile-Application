import 'package:flutter/widgets.dart';
import 'package:food_mobile_app/admin-pages/categories/categories.dart';
import 'package:food_mobile_app/admin-pages/home/home.dart';
import 'package:food_mobile_app/admin-pages/orders/orders.dart';
import 'package:food_mobile_app/admin-pages/products/products.dart';
import 'package:food_mobile_app/admin-pages/profile_admin/profile_admin.dart';
import 'package:food_mobile_app/pages/cart_page.dart';
import 'package:food_mobile_app/pages/sign_in/sign_in.dart';
import '../pages/complete_profile/complete_profile_screen.dart';
import '../pages/forgot_password/forgot_password.dart';
import '../pages/sign_up/sign_up.dart';
import 'package:food_mobile_app/routes/home_route.dart';
import 'package:food_mobile_app/routes/products_route.dart';
import 'package:food_mobile_app/routes/settings_route.dart';
import 'package:food_mobile_app/routes/cart_route.dart';

// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) =>   const SignInScreen(),
  ...homeRoutes,
  ...settingsRoutes,
  ...productsRoutes,
  ...cartsRoutes,
  CartPage.routeName: (context) =>   const CartPage(),
  ForgotPasswordScreen.routeName: (context) =>   const ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  AdminHomePage.routeName: (context) =>   const AdminHomePage(),
  AdminProfilePage.routeName : (context) => const AdminProfilePage(),
  AdminProductPage.routeName : (context) => const AdminProductPage(),
  AdminCategoryPage.routeName : (context) => const AdminCategoryPage(),
  AdminOrderPage.routeName : (context) => const AdminOrderPage(),
};