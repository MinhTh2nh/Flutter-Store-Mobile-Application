import 'package:flutter/material.dart';
import 'package:food_mobile_app/admin-pages/profile_admin/profile_admin.dart';
import 'package:provider/provider.dart'; // Import Provider package
import '../../model/cart_model.dart';
import '../../pages/cart_page.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CustomAppBarState createState() => _CustomAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    );

    const sizeIcon = BoxConstraints.tightFor(
      width: 40,
      height: 40,
    );

    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.teal.shade100,
            width: 1.0,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: TextField(
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(4),
                    focusedBorder: border,
                    enabledBorder: border,
                    isDense: true,
                    hintText: "TIU....",
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.teal.shade200,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    prefixIconConstraints: sizeIcon,
                    suffixIcon: const Icon(
                      Icons.camera_alt_outlined,
                    ),
                    suffixIconConstraints: sizeIcon,
                    border: InputBorder.none,
                    filled: true,
                    fillColor:
                    _searchFocusNode.hasFocus ? Colors.white : Colors.transparent,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [
        Consumer<CartModel>(
          builder: (context, cart, child) {
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AdminProfilePage.routeName);
                  },
                  icon: const Icon(Icons.person),

                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
