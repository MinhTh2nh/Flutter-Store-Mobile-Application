import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../model/order_detail_model.dart';
import '../constants.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static String routeName = "/order-management";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderDetailModel orderDetailModel = OrderDetailModel();
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = orderDetailModel.fetchOrdersByCustomerId(globalCustomerId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: ListTile(
                        title: Text('Order: ${order.orderId}'),
                        subtitle: Text(
                            'Date: ${DateFormat('dd/MM/yyyy').format(order.orderDate)}'),
                        trailing: Text('Status: ${order.orderStatus}',
                            style: TextStyle(
                                color: _getStatusColor(order.orderStatus),
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.orderDetails.length,
                      itemBuilder: (context, detailIndex) {
                        final detail = order.orderDetails[detailIndex];
                        return Column(
                          children: [
                            ListTile(
                              leading: Image.network(
                                detail.product.productThumbnail,
                                fit: BoxFit.contain,
                              ),
                              title: Text(
                                'Product: ${detail.product.productName}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${detail.product.category.categoryName}, ${detail.product.subCategory.subName}, ${detail.product.size.sizeName} '),
                                      Text('Quantity: ${detail.quantity}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          'Price: \$${detail.product.productPrice}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red.shade500)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (order.orderStatus == 'Successful')
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Write Review'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const TextField(
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Write your review here',
                                                ),
                                              ),
                                              RatingBar.builder(
                                                initialRating: 3,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  // ignore: avoid_print
                                                  print(rating);
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Submit'),
                                              onPressed: () {
                                                // Handle submit button press
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: const Text('Write Review'),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    Container(
                      color: Colors.grey,
                      // height: 5,
                      padding: const EdgeInsets.all(5),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'Pending':
      return Colors.orange;
    case 'Delivering':
      return Colors.blue;
    case 'Successful':
      return Colors.green;
    case 'Cancelled':
      return Colors.red;
    case 'Processing':
      return Colors.purple;
    default:
      return Colors.grey;
  }
}
