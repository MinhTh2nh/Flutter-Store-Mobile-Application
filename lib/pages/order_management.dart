import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // Add this line

class Order {
  final String id;
  final String title;
  final DateTime date;
  final String status; // Add this line

  Order(
      {required this.id,
      required this.title,
      required this.date,
      required this.status}); // Update this line
}

class OrdersScreen extends StatelessWidget {
  final List<Order> orders = [
    Order(
        id: '1', title: 'Order 1', date: DateTime.now(), status: 'Successful'),
    Order(
        id: '2', title: 'Order 2', date: DateTime.now(), status: 'Processing'),
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
        itemBuilder: (ctx, i) => Card(
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
                subtitle: Text(DateFormat('dd/MM/yyyy').format(orders[i].date)),
                trailing: IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: () {
                    // Navigate to order details page
                  },
                ),
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
    case 'Processing': // Add this line
      return Colors.purple; // Add this line
    default:
      return Colors.grey;
  }
}
