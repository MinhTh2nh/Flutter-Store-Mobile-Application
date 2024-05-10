import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_mobile_app/model/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:food_mobile_app/components/address_management.dart';

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

  void onAddressSelected(String address, String phone) {
    setState(() {
      selectedAddress = address;
      selectedPhoneNumber = phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deliveryFee = 2.0; // Initialize delivery fee to $2
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
                            if (selectedAddress != null &&
                                selectedPhoneNumber != null)
                              Text('$selectedPhoneNumber'),
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
                      '\$${((double.parse(value.calculateTotal()).toInt()) + deliveryFee).toStringAsFixed(2)}',
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
            // TODO: Implement order functionality
          },
        ),
      ),
    );
  }
}
