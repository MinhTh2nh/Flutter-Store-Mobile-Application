import 'package:flutter/material.dart';
import 'package:food_mobile_app/pages/order.dart';
import 'package:provider/provider.dart';
import '../model/cart_model.dart';

class CartPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CartPage({Key? key});
  static String routeName = "/cart-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<CartModel>(
        builder: (context, value, child) {
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
                        // Check if the cartItem contains the 'item_id' field
                        if (cartItem.containsKey('item_id') &&
                            cartItem['item_id'] != null) {
                          // Find the product item corresponding to the cart item
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
                                  height: 36,
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
                          // Return a fallback widget if 'item_id' field is null or not present
                          return const SizedBox.shrink();
                        }
                      },
                    )),
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
                        onTap: value.cartItems.isNotEmpty
                            ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return const OrderPage();
                                  }),
                                )
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.tealAccent),
                            borderRadius: BorderRadius.circular(28),
                            color: value.cartItems.isNotEmpty
                                ? Colors.tealAccent
                                : Colors.grey,
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
        },
      ),
    );
  }
}
