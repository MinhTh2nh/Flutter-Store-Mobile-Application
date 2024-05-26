// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_mobile_app/pages/checkout_process/paymentStripe.dart';
import 'package:provider/provider.dart';
import 'package:food_mobile_app/model/cart_model.dart';
import '../../payment/paypal/makePayment.dart'; // Import the new function
import '../../model/order_model.dart';
import '../../constants.dart';

class OrderPaymentScreen extends StatefulWidget {
  final Order order;

  const OrderPaymentScreen({required this.order, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderPaymentScreenState createState() => _OrderPaymentScreenState();
}

class _OrderPaymentScreenState extends State<OrderPaymentScreen> {
  String? selectedPaymentMethod;
  String paymentMethodStatus = "incompleted";
  int? _type;

  @override
  void initState() {
    super.initState();
    // Set the publishable key
    Stripe.publishableKey = 'pk_test_51PJfH1EncpehfcF0tTPnvcpp8d4SxwQmYtYa9f1tOohG6wz4JsnYltX1BTDOCHrg9SVei5Ym0ME7H90yxP3pFrkw00IhjvE2mK';
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await createPaymentIntent(
        name: widget.order.customerId.toString(),
        address: widget.order.shippingAddress,
        pin: '000000',
        city: 'City',
        state: 'State',
        country: 'VietNam',
        currency: 'USD',
        amount: (widget.order.totalPrice * 100).toInt().toString(),
      );

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['customer'],
          style: ThemeMode.system,
        ),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    double deliveryFee = 2.0; // Initialize delivery fee to $2
    double totalPrice =
        double.parse(Provider.of<CartModel>(context).calculateTotal()) +
            deliveryFee;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Payment',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                _buildPaymentMethodRow(
                    size, "Stripe", "lib/images/stripelogo.png", 1),
                const SizedBox(height: 20),
                _buildPaymentMethodRow(
                    size, "Paypal", "lib/images/paypallogo.png", 2),
                const SizedBox(height: 20),
                _buildPaymentMethodRow(
                    size, "VNPay", "lib/images/vnpay.png", 3),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(Colors.teal.shade200),
          ),
          child: const Text('Proceed to payment',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          onPressed: () async {
            int orderQuantity =
                Provider.of<CartModel>(context, listen: false).cartItems.length;

            // Ensure selectedPaymentMethod is not null
            if (selectedPaymentMethod != null) {
              // Initialize payment status
              String paymentMethodStatus = "incompleted";

              // Create the order object
              var order = Order(
                customerId: globalCustomerId!,
                orderQuantity: orderQuantity,
                paymentStatus: paymentMethodStatus,
                orderAddress: '123 Shipping Address',
                shippingAddress: widget.order.shippingAddress,
                phoneNumber: widget.order.phoneNumber,
                paymentType: selectedPaymentMethod!,
                totalPrice: totalPrice,
                items: Provider.of<CartModel>(context, listen: false)
                    .cartItems
                    .map((item) => OrderItem(
                  detailPrice: item['product_price'].toDouble(),
                  itemId: item['item_id'],
                  quantity: item['quantity'],
                ))
                    .toList(),
              );

              if (selectedPaymentMethod == "Stripe") {
                await initPaymentSheet();

                try {
                  await Stripe.instance.presentPaymentSheet();

                  // Update payment status to completed
                  setState(() {
                    paymentMethodStatus = "completed";
                  });
                  // Create the order with the updated payment status
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Payment Done",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ));

                  // Clear the cart
                  Provider.of<CartModel>(context, listen: false).clearCart();
                  // Navigate to a success page or perform other actions

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Payment Failed",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  ));
                }
              }
              else if (selectedPaymentMethod == "Paypal") {
                // PayPal payment logic
                startPaypalPayment(context, order, (number) async {
                  // Payment done
                  setState(() {
                    paymentMethodStatus = "completed";
                  });

                  // Create the order with the updated payment status
                  createOrder(context, order);

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Payment Done",
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.green,
                  ));

                  // Clear the cart
                  Provider.of<CartModel>(context, listen: false).clearCart();
                  // Navigate to a success page or perform other actions
                });
              }
              else {
                // Handle other payment methods like VNPay
                // Example: Navigate to their respective payment screens
                // createOrder(context, order);
              }
            } else {
              // Handle the case where payment method is not selected
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  "Please select a payment method.",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
              ));
            }
          },
        ),
      ),
    );
  }

  Widget _buildPaymentMethodRow(
      Size size, String method, String imagePath, int value) {
    return Container(
      width: size.width,
      height: 55,
      decoration: BoxDecoration(
        border: _type == value
            ? Border.all(width: 1, color: const Color(0xFFDB3022))
            : Border.all(width: 0.7, color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Radio(
                    value: value,
                    groupValue: _type,
                    onChanged: (int? selectedValue) {
                      setState(() {
                        _type = selectedValue;
                        selectedPaymentMethod =
                            method; // Set selectedPaymentMethod when radio button is selected
                      });
                    },
                    activeColor: const Color(0xFFDB3022),
                  ),
                  Text(
                    method,
                    style: _type == value
                        ? const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    )
                        : const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Image.asset(
                imagePath,
                width: 150,
                height: 70,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
