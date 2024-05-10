import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: const [
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
          ),
          DrawerListTile(
            title: "PRODUCTS",
            leading: Icons.shopping_bag,
          ),
          DrawerListTile(
            title: "CATEGORIES",
            leading: Icons.category,
          ),
          DrawerListTile(
            title: "LOG OUT",
            leading: Icons.logout,
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
  }) : super(key: key);

  final String title;
  final IconData leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16), // Adjust the margin as needed
      child: ListTile(
        horizontalTitleGap: 0.0,
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
