import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_mobile_app/pages/order.dart';
import 'package:provider/provider.dart';
import '../components/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../components/custome_app_bar/custom_app_bar.dart';
import '../model/cart_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key});
  static String routeName = "/cart-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(
        children: [
          Consumer<CartModel>(
            builder: (context, value, child) {
              if (value.cartItems.isEmpty) {
                return _buildEmptyCartView();
              } else {
                return _buildCartListView(context, value) ;
              }
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: const CustomAppBar(),
          ),
        ],
      ),
      bottomNavigationBar:BottomNavigationBarWrapper(
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/products');
              break;
            case 2:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
    );
  }

  Widget _buildEmptyCartView() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 70,
              child: Container(
                color: Color(0xFFFFFFFF),
              ),
            ),
            Container(
              width: double.infinity,
              height: 250,
              child: Image.asset(
                "lib/images/empty_shopping_cart_image.png",
                height: 250,
                width: double.infinity,
              ),
            ),
            SizedBox(
              height: 40,
              child: Container(
                color: Color(0xFFFFFFFF),
              ),
            ),
            Container(
              width: double.infinity,
              child: Text(
                "You haven't added anything to the cart",
                style: TextStyle(
                  color: Color(0xFF67778E),
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartListView(BuildContext context, CartModel value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "My Cart",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: ListView.builder(
              itemCount: value.cartItems.length,
              itemBuilder: (context, index) {
                var cartItem = value.cartItems[index];
                if (cartItem.containsKey('item_id') &&
                    cartItem['item_id'] != null) {
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Image.network(
                          cartItem['imagePath'],
                          height: 36,
                        ),
                        title: Text(
                          cartItem['name'],
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${cartItem['itemPrice']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Quantity: ${cartItem['quantity']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () => Provider.of<CartModel>(context,
                              listen: false)
                              .removeItemFromCart(index),
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(36),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.teal.shade200,
            ),
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Price',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      '\$${value.calculateTotal()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Use Builder to get the context
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const OrderPage();
                      }),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.tealAccent),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Row(
                      children: [
                        Text(
                          'Pay Now',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
