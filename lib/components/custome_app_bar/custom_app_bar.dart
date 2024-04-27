import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_mobile_app/model/cart_model.dart';
import '../../pages/cart_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Padding(
        padding: EdgeInsets.only(left: 24),
        child: Text(
          'D Baku',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: () {
              // Action for the first button (e.g., search)
            },
            icon: const Icon(Icons.search),
          ),
        ),
        Consumer<CartModel>(
          builder: (context, cart, child) => Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const CartPage();
                      },
                    ),
                  ),
                  icon: const Icon(
                    Icons.shopping_basket,
                  ),
                ),
                if (cart.itemsCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        cart.itemsCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
