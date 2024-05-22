import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/order_detail_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade100),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order ID: ${order.orderId}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                      'Date: ${DateFormat('dd/MM/yyyy').format(order.orderDate)}',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.teal.shade800,
                          size: 24.0,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.teal.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order.shippingAddress,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      order.phoneNumber ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.payment,
                              color: Colors.teal.shade800,
                              size: 24.0,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Payment Method',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.teal.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.paymentType,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          order.paymentStatus,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Order Items:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Status: ${order.orderStatus}',
                      style: TextStyle(
                          fontSize: 16,
                          color: _getStatusColor(order.orderStatus))),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: order.orderDetails.length,
                  itemBuilder: (context, index) {
                    final detail = order.orderDetails[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Image.network(detail.product.productThumbnail,
                            fit: BoxFit.cover, width: 50, height: 50),
                        title: Text(detail.product.productName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${detail.product.category.categoryName}, ${detail.product.subCategory.subName}, ${detail.product.size.sizeName}'),
                            Text('Quantity: ${detail.quantity}'),
                          ],
                        ),
                        trailing: Text('\$${detail.product.productPrice}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red)),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: Text('Total Price: \$${order.totalPrice}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ),
            ],
          ),
        ),
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
