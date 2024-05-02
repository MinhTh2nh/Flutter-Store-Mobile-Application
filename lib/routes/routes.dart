import 'package:flutter/widgets.dart';
import 'package:food_mobile_app/pages/cart_page.dart';
import 'package:food_mobile_app/pages/sign_in/sign_in.dart';
import 'package:food_mobile_app/routes/products_route.dart';
import 'package:food_mobile_app/routes/settings_route.dart';
import '../pages/complete_profile/complete_profile_screen.dart';
import '../pages/forgot_password/forgot_password.dart';
import '../pages/login_success/login_success.dart';
import '../pages/sign_up/sign_up.dart';
import 'package:food_mobile_app/routes/home_route.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) =>   const SignInScreen(),
  ...homeRoutes,
  ...settingsRoutes,
  ...productsRoutes,
  ForgotPasswordScreen.routeName: (context) =>   const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  CartPage.routeName: (context) => const CartPage(),
};