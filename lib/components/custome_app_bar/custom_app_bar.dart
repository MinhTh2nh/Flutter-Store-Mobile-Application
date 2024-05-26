import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/cart_model.dart';
import '../../pages/shopping_cart/cart_page.dart';
import '../../pages/products/seach_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.grey.shade200,
      automaticallyImplyLeading: false,
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
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    ).then((_) {
                      // Set focus on search field after returning from search screen
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.teal,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Search...",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.teal,
                      ), // Add camera icon
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Consumer<CartModel>(
          builder: (context, cart, child) {
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartPage.routeName);
                  },
                  icon: const Icon(Icons.shopping_basket),
                ),
                if (cart.cartItems.isNotEmpty)
                  Positioned(
                    top: 2,
                    right: 5,
                    child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
