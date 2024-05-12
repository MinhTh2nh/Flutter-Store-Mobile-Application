// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Order {
  final int customerId;
  final int orderQuantity;
  final String orderAddress;
  final String shippingAddress;
  final String phoneNumber;
  final double totalPrice;
  final List<OrderItem> items;

  Order({
    required this.customerId,
    required this.orderQuantity,
    required this.orderAddress,
    required this.shippingAddress,
    required this.phoneNumber,
    required this.totalPrice,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'order_quantity': orderQuantity,
      'order_address': orderAddress,
      'shipping_address': shippingAddress,
      'phone_number': phoneNumber,
      'total_price': totalPrice,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final double detailPrice;
  final int itemId;
  final int quantity;

  OrderItem({
    required this.detailPrice,
    required this.itemId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'detail_price': detailPrice,
      'item_id': itemId,
      'quantity': quantity,
    };
  }
}

Future<void> createOrder(BuildContext context, Order order) async {
  const String apiUrl =
      'https://flutter-store-mobile-application-backend.onrender.com/orders/create';
  try {
    final jsonData = jsonEncode(order.toJson());

    //send a POST request to the API endpoint
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    //Check if the request is successful
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromARGB(255, 78, 204, 82),
          content: Text(
            'Order created successfully',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
      print('Order created successfully');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Failed to create order: ${response.statusCode}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
      print('Failed to create order: ${response.statusCode}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Network error: $e'),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
    print('Network error: $e');
  }
}
