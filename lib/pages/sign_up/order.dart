import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_mobile_app/model/cart_model.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  static String routeName = "/order-page";

  const OrderPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<String> deliveryAddresses = ['Address 1', 'Address 2', 'Address 3'];
  String? selectedAddress;

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
                child: DropdownButton<String>(
                  value: selectedAddress,
                  hint: const Text('Select Address'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAddress = newValue;
                    });
                  },
                  items: deliveryAddresses
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: value.cartItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              leading: Image.asset(
                                value.cartItems[index][2],
                                height: 36,
                              ),
                              title: Text(
                                value.cartItems[index][0],
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(
                                '\$' + value.cartItems[index][1],
                                style: const TextStyle(fontSize: 12),
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
                    trailing: Text('\$${deliveryFee.toString()}'),
                  ),
                  ListTile(
                    title: const Text('Total'),
                    trailing: Text(
                        '\$${(value.calculateTotal() + deliveryFee.toString()).toString()}'),
                  ),
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
          child: const Text('Order', style: TextStyle(color: Colors.white)),
          onPressed: () {
            // TODO: Implement order functionality
          },
        ),
      ),
    );
  }
}
