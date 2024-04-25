import 'package:flutter/material.dart';
import 'package:food_mobile_app/pages/forgot_password/forgot_password.dart';
import 'package:food_mobile_app/pages/home.dart';
import 'package:food_mobile_app/pages/sign_in/sign_in.dart';
import 'package:food_mobile_app/pages/sign_up/sign_up.dart';
import 'package:food_mobile_app/pages/products.dart';
import 'package:food_mobile_app/pages/settings.dart';
import 'package:food_mobile_app/pages/cart_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:food_mobile_app/model/cart_model.dart';
import 'backend/controllers/auth_controller.dart';
import 'consts/consts.dart';
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        title: appName,
        initialRoute: '/sign_in', // Set the initial route to '/sign_in'
        routes: {
          '/sign_in': (context) => const SignInScreen(), // Route for sign in
          '/home': (context) => const HomePage(), // Route for home page
          '/sign_up': (context) => const SignUpScreen(), // Route for sign in
          '/forgot_password': (context) => const ForgotPasswordScreen(), // Route for sign in
        },
      ),
    );
  }
}

// This class represents the main screen of the app after the user has signed in.
class HomePage extends StatefulWidget {
  // ignore: use_super_parameters
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Home(),
    const Products(),
    const Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Text(
            'D Baku',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        actions: const [
          // Action buttons in the app bar
        ],
      ),
      body: _pages[_selectedIndex], // Displaying the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal.shade200,
        onTap: _onItemTapped,
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
}