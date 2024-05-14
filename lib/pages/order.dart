import 'package:flutter/material.dart';
import 'package:food_mobile_app/model/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:food_mobile_app/components/address_management.dart';
import '../model/order_model.dart';
import '../constants.dart';

class OrderPage extends StatefulWidget {
  static String routeName = "/order-page";

  const OrderPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? selectedAddress;
  String? selectedPhoneNumber;

  void onAddressSelected(String address, String phoneNumber) {
    print(
        'onAddressSelected called with address: $address and phone: $phoneNumber');

    setState(() {
      selectedAddress = address;
      selectedPhoneNumber = phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deliveryFee = 2.0; // Initialize delivery fee to $2
    double totalPrice =
        double.parse(Provider.of<CartModel>(context).calculateTotal()) +
            deliveryFee;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<CartModel>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Delivery Address',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(selectedAddress != null
                                ? '$selectedAddress'
                                : 'No address selected'),
                            Text(selectedPhoneNumber != null
                                ? '$selectedPhoneNumber'
                                : 'No phone number selected'),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return AddressManagement(
                                    onAddressSelected: onAddressSelected);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: ListView.builder(
                      itemCount: value.cartItems.length,
                      itemBuilder: (context, index) {
                        var cartItem = value.cartItems[index];

                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8)),
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
                                onPressed: () => Provider.of<CartModel>(context,
                                        listen: false)
                                    .removeItemFromCart(index),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              const Divider(),
              Column(
                children: [
                  ListTile(
                    title: const Text('Subtotal'),
                    trailing: Text('\$${value.calculateTotal()}'),
                  ),
                  ListTile(
                    title: const Text('Delivery Fee'),
                    trailing: Text('\$${deliveryFee.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: const Text('Total'),
                    trailing: Text(
                      '\$$totalPrice',
                    ),
                  )
                ],
              )
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.teal.shade200),
          ),
          child: const Text('Order',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          onPressed: () {
            int orderQuantity =
                Provider.of<CartModel>(context, listen: false).cartItems.length;

            // Check if both address and phone number are selected
            if (selectedAddress != null && selectedPhoneNumber != null) {
              createOrder(
                  context,
                  Order(
                    customerId: globalCustomerId!,
                    orderQuantity: orderQuantity,
                    orderAddress: '123 Shipping Address',
                    shippingAddress: selectedAddress!,
                    phoneNumber: selectedPhoneNumber!,
                    totalPrice: totalPrice,
                    items: Provider.of<CartModel>(context, listen: false)
                        .cartItems
                        .map((item) => OrderItem(
                              detailPrice: item['product_price'].toDouble(),
                              itemId: item['item_id'],
                              quantity: item['quantity'],
                            ))
                        .toList(),
                  ));
            } else {
              // Show a snackbar if address or phone number is not selected
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Please select both address and phone number.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  duration:
                      Duration(seconds: 3), // Adjust the duration as needed
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
