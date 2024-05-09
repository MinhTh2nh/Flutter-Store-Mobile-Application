import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider package
import '../../model/cart_model.dart';
import '../../pages/cart_page.dart';

class CustomAppBarForDetailPage extends StatefulWidget
    implements PreferredSizeWidget {
  const CustomAppBarForDetailPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomAppBarForDetailPageState createState() =>
      _CustomAppBarForDetailPageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarForDetailPageState extends State<CustomAppBarForDetailPage> {
  late FocusNode _searchFocusNode; // Declare a FocusNode

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
      // Use OutlineInputBorder instead of InputBorder.all
      borderSide: BorderSide(
        color: Colors.teal.shade100,
        width: 1.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(10),
    );

    const sizeIcon = BoxConstraints.tightFor(
      width: 40,
      height: 40,
    );

    return AppBar(
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      // Disable back button automatically appearing
      backgroundColor: Colors.white,
      // Change background color based on scroll
      // Add the search field
      title: Row(
        children: [
          // Back icon
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          // Expanded search field
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
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
        ],
      ),
      actions: [
        Consumer<CartModel>(
          // Use Consumer to listen to changes in CartModel
          builder: (context, cart, child) {
            return Stack(
              children: [
                // Cart icon
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartPage.routeName);
                  },
                  icon: const Icon(Icons.shopping_basket),
                ),
                if (cart.cartItems
                    .isNotEmpty) // Conditionally show the notification badge
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
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
