import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // Add this line

class Product {
  final String name;
  final int quantity;

  Product({required this.name, required this.quantity});
}

class Order {
  final String id;
  final String title;
  final DateTime date;
  final String status;
  final List<Product> products;

  Order({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.products,
  });
}

class OrdersScreen extends StatelessWidget {
  final List<Order> orders = [
    Order(
      id: '1',
      title: 'Order 1',
      date: DateTime.now(),
      status: 'Successful',
      products: [
        Product(name: 'Product 1', quantity: 2),
        Product(name: 'Product 2', quantity: 1),
      ],
    ),
    Order(
      id: '2',
      title: 'Order 2',
      date: DateTime.now(),
      status: 'Delivering',
      products: [
        Product(name: 'Product 1', quantity: 2),
      ],
    ),
    // Add more orders here
  ];

  OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, i) => ExpansionTile(
          title: Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: FittedBox(
                        child: Text('#${orders[i].id}'),
                      ),
                    ),
                  ),
                  title: Text(orders[i].title),
                  subtitle:
                      Text(DateFormat('dd/MM/yyyy').format(orders[i].date)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _getStatusColor(orders[i].status),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Status: ${orders[i].status}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          children: orders[i].products.map((product) {
            return Column(
              children: [
                ListTile(
                  title: Text(product.name),
                  trailing: Text('Quantity: ${product.quantity}'),
                ),
                if (orders[i].status == 'Successful')
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity, // Set the width of the container
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.rate_review),
                          color: Colors.white,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Review for ${product.name}'),
                                content: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Write a review',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSubmitted: (value) {
                                    // Handle review submission
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('Submit'),
                                    onPressed: () {
                                      // Handle submit button press
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Text(
                          'Review',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
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
