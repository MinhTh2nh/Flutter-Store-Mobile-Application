// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../model/order_detail_model.dart';
import '../constants.dart';
import 'package:intl/intl.dart';
import '../model/review_model.dart';
import '../model/cart_model.dart';

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

  Future<void> submitReview(int itemId, double rating, String comment) async {
    // Implement submit review
    try {
      await Review.addReview(
          reviewRating: rating,
          reviewComment: comment,
          itemId: itemId,
          customerId: globalCustomerId!);

      // Optionally, refresh the products list after submitting the review
      await CartModel().fetchProducts();
      // Optionally, you can refresh the orders list after review submission
      setState(() {
        _ordersFuture =
            orderDetailModel.fetchOrdersByCustomerId(globalCustomerId!);
      });
      // Show a success message or perform any other actions as needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully'),
        ),
      );
    } catch (error) {
      // Handle errors, e.g., display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit review: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            return Container(
              color: Colors.grey.shade100,
              // Set the background color of the parent container
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: Colors.white,
                    ),
                    // Wrap the child elements in another Container
                    // Set the background color of the child container
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Order: ${order.orderId}'),
                          subtitle: Text(
                              'Date: ${DateFormat('dd/MM/yyyy').format(order.orderDate)}'),
                          trailing: Text('Status: ${order.orderStatus}',
                              style: TextStyle(
                                  color: _getStatusColor(order.orderStatus),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order.orderDetails.length,
                          itemBuilder: (context, detailIndex) {
                            final detail = order.orderDetails[detailIndex];
                            return Container(
                              // Wrap the child elements in another Container
                              color: Colors.white,
                              // Set the background color of the child container
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Image.network(
                                      detail.product.productThumbnail,
                                      fit: BoxFit.contain,
                                    ),
                                    title: Text(
                                      ' ${detail.product.productName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '${detail.product.category.categoryName}, ${detail.product.subCategory.subName}, ${detail.product.size.sizeName} '),
                                            Text(
                                                'Quantity: ${detail.quantity}'),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(''),
                                            Text(
                                              ' \$${detail.product.productPrice}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (order.orderStatus == 'successful')
                                    SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              TextEditingController
                                                  reviewController =
                                                  TextEditingController();

                                              double rating = 3;
                                              return AlertDialog(
                                                title:
                                                    const Text('Write Review'),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          reviewController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Write your review here',
                                                      ),
                                                    ),
                                                    RatingBar.builder(
                                                      initialRating: 3,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 4.0),
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate:
                                                          (newRating) {
                                                        rating = newRating;
                                                        print(rating);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Submit'),
                                                    onPressed: () {
                                                      int itemId =
                                                          detail.itemId;
                                                      rating = rating;
                                                      String comment =
                                                          reviewController.text;
                                                      submitReview(itemId,
                                                          rating, comment);
                                                      Navigator.of(context)
                                                          .pop();
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
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Total Price: \$${order.totalPrice}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          color: Colors.grey.shade200,
                          // Set the background color of the bottom container
                          padding: const EdgeInsets.all(15),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'delivering':
      return Colors.blue;
    case 'successful':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    case 'processing':
      return Colors.purple;
    default:
      return Colors.grey;
  }
}
