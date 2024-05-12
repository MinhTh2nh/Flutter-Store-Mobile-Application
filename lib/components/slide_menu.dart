import 'package:flutter/material.dart';
import 'package:food_mobile_app/admin-pages/categories/categories.dart';
import 'package:food_mobile_app/admin-pages/home/home.dart';
import 'package:food_mobile_app/admin-pages/products/products.dart';
import 'package:food_mobile_app/pages/sign_in/sign_in.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children:  [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("lib/images/main_image.png")),
            ),
            child: null,
          ),
          DrawerListTile(
            title: "DASHBOARD",
            leading: Icons.home,
            onPressed: () {
              Navigator.pushNamed(context, AdminHomePage.routeName);
            },
          ),
          DrawerListTile(
            title: "PRODUCTS",
            leading: Icons.shopping_bag,
            onPressed: () {
              Navigator.pushNamed(context, AdminProductPage.routeName);
            },
          ),
          DrawerListTile(
            title: "CATEGORIES",
            leading: Icons.category,
            onPressed: () {
              Navigator.pushNamed(context, AdminCategoryPage.routeName);
            },
          ),
          DrawerListTile(
            title: "LOG OUT",
            leading: Icons.logout,
            onPressed: () {
              Navigator.pushNamed(context, SignInScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.leading,
    required this.onPressed, // Add this parameter
  }) : super(key: key);

  final String title;
  final IconData leading;
  final VoidCallback onPressed; // Define a callback for onPressed

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16), // Adjust the margin as needed
      child: ListTile(
        horizontalTitleGap: 0.0,
        onTap: onPressed, // Assign the onPressed callback to onTap
        leading: Row(
          mainAxisSize: MainAxisSize.min, // Ensure the row takes minimum space
          children: [
            Icon(
              leading,
              color: Colors.black54,
            ),
            SizedBox(width: 16), // Add margin between Icon and Text
          ],
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
