import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_mobile_app/components/buttons.dart';
import 'package:food_mobile_app/pages/order.dart';
import 'package:provider/provider.dart';
import '../components/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../model/cart_model.dart';
import '../../components/custome_app_bar/custom_app_bar.dart';

class CartPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CartPage({Key? key});

  static String routeName = "/cart-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer<CartModel>(
        builder: (context, value, child) {
          if (value.cartItems.length == 0) {
            // Display empty cart image if cart is empty
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Oops, your cart is empty",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    'lib/images/empty_shopping_cart_image.png',
                    width: double.infinity, // Take whole width
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  buttons(
                      title: "Back to shopping",
                      color: Colors.teal.shade200,
                      textColor: Colors.white,
                      onPress: () {
                        Navigator.pushNamed(context, '/home');
                      })
                ],
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                                  cartItem['product_thumbnail'],
                                  // height: 36,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  cartItem['product_name'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '\$${cartItem['product_price']}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      'Quantity: ${cartItem['quantity']}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      'Size: ${cartItem['selectedSize']}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () => Provider.of<CartModel>(
                                          context,
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const OrderPage();
                            }),
                          ),
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
        },
      ),
      bottomNavigationBar: BottomNavigationBarWrapper(
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
}
