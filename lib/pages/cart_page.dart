import 'package:flutter/material.dart';
import 'package:food_mobile_app/components/buttons.dart';
import 'package:food_mobile_app/pages/order.dart';
import 'package:provider/provider.dart';
import '../model/cart_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static String routeName = "/cart-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      ),
      body: Consumer<CartModel>(
        builder: (context, value, child) {
          if (value.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Oops, your cart is empty",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    'lib/images/empty_shopping_cart_image.png',
                    width: double.infinity,
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
                            child: SizedBox(
                              child: Dismissible(
                                key: Key(cartItem['item_id'].toString()),
                                direction: DismissDirection.endToStart,
                                background: stackBehindDismiss(),
                                onDismissed: (direction) {
                                  Provider.of<CartModel>(context, listen: false)
                                      .removeItemFromCart(index);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    leading: Image.network(
                                      cartItem['product_thumbnail'],
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(
                                      cartItem['product_name'],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(21.0),
                      topRight: Radius.circular(21.0),
                    ),
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
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget stackBehindDismiss() {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
