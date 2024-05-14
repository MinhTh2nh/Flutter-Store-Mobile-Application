import 'package:flutter/material.dart';
import 'package:food_mobile_app/pages/products.dart';
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
  late FocusNode _searchFocusNode; // Declare a FocusNode
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode(); // Initialize the FocusNode
  }

  @override
  void dispose() {
    _searchFocusNode.dispose(); // Dispose the FocusNode
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
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white, // Change background color based on scroll
      // Add the search field
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Products.routeName,
                      arguments: _searchController.text,
                    );
                  },
                  child: TextField(
                    focusNode: _searchFocusNode, // Assign the FocusNode
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
                      fillColor: _searchFocusNode.hasFocus
                          ? Colors.white
                          : Colors.transparent, // Change color based on focus
                    ),
                    onChanged: (value) {
                      setState(() {
                        // No need to track background color anymore
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Consumer<CartModel>(
          // Use Consumer to listen to changes in CartModel
          builder: (context, cart, child) {
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartPage.routeName);
                  },
                  icon: const Icon(Icons.shopping_basket),
                ),
                if (cart.cartItems
                    .isNotEmpty) // Conditionally show the notification badge
                  Positioned(
                    top: 2,
                    right: 5,
                    child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      // padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        cart.itemsCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
