import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../components/buttons.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;
  final void Function() onUpdate;

  const OrderDetailPage({Key? key, required this.orderId, required this.onUpdate}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}


class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<Order> _orderFuture;
  String? selectedStatus;
  String? selectedPaymentStatus;

  @override
  void initState() {
    super.initState();
    _orderFuture = fetchOrderDetails(widget.orderId);
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

  void _handleUpdate() {
    widget.onUpdate();
  }

  Future<void> _updateOrderStatus() async {
    var path = "https://flutter-store-mobile-application-backend.onrender.com/orders/update/${widget.orderId}/status";
    try {
      final response = await http.put(
        Uri.parse(path),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"order_status": selectedStatus , "payment_status": selectedPaymentStatus}),
      );
      if (response.statusCode == 200) {
        // Successfully updated the status
        setState(() {
          _orderFuture = fetchOrderDetails(widget.orderId);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order status updated successfully.')));
        _handleUpdate();

    } else {
        throw Exception('Failed to update order status: ${response.statusCode}');
        _handleUpdate();
      }
    } catch (error) {
      print('Error updating order status: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating order status.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: FutureBuilder<Order>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final order = snapshot.data!;
            selectedStatus ??= order.orderStatus;
            selectedPaymentStatus ??= order.orderPaymentStatus;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          'Order: ${order.orderId}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          'Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(order.orderDate))}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        trailing:
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.teal.shade200,
                          ),
                          child:  DropdownButton<String>(
                            value: selectedStatus,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedStatus = newValue;
                              });
                            },
                            items: <String>[
                              'pending',
                              'delivering',
                              'successful',
                              'cancelled',
                              'processing',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    value[0].toUpperCase() + value.substring(1),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            style: TextStyle(color: Colors.black),
                            dropdownColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Order Address: ${order.orderAddress}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Shipping Address: ${order.shippingAddress}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (order.phoneNumber != null)
                            Text(
                              'Phone Number: ${order.phoneNumber}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "The Order Details:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${order.orderPrice}\$",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "The Order Payment Status:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.teal.shade200,
                          ),
                          child:
                          DropdownButton<String>(
                            value: selectedPaymentStatus,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedPaymentStatus = newValue;
                              });
                            },
                            items: <String>[
                              'incompleted',
                              'completed',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    value[0].toUpperCase() + value.substring(1),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            style: TextStyle(color: Colors.black),
                            dropdownColor: Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.orderDetail.length,
                      itemBuilder: (context, detailIndex) {
                        final detail = order.orderDetail[detailIndex];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Image.network(
                              detail.product.productThumbnail,
                              fit: BoxFit.contain,
                              width: 50,
                              height: 50,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product: ${detail.product.productName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${detail.product.category.categoryName}, ${detail.product.subCategory.subName}, ${detail.product.size.sizeName}',
                                        ),
                                        Text('Quantity: ${detail.quantity}'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Price: \$${detail.product.productPrice}',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    buttons(
                      title: "UPDATE",
                      color: Colors.teal.shade200,
                      textColor: Colors.white,
                      onPress: _updateOrderStatus,
                    ).box.width(context.screenWidth).make(),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<Order> fetchOrderDetails(int orderId) async {
    var path = "https://flutter-store-mobile-application-backend.onrender.com/orders/get/$orderId";
    try {
      final response = await http.get(Uri.parse(path));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        // Parse the responseData and create an Order object
        return Order(
          orderId: responseData['order_id'],
          orderStatus: responseData['order_status'],
          orderPaymentStatus : responseData['payment_status'],
          orderPaymentMethod : responseData['payment_type'],
          orderDate: responseData['order_date'],
          orderPrice: responseData['total_price'].toString(),
          orderAddress: responseData['order_address'],
          shippingAddress: responseData['shipping_address'],
          phoneNumber: responseData['phoneNumber'], // Handle nullable phone number
          orderDetail: (responseData['order_details'] as List<dynamic>).map((detail) {
            return OrderDetail(
              product: Product(
                productName: detail['product']['product_name'],
                productPrice: double.parse(detail['product']['product_price'].toString()),
                productThumbnail: detail['product']['product_thumbnail'],
                category: Category(
                  categoryName: detail['product']['category']['category_name'],
                ),
                subCategory: SubCategory(
                  subName: detail['product']['sub_category']['sub_name'],
                ),
                size: Size(
                  sizeName: detail['size']['size_name'],
                ),
              ),
              quantity: detail['quantity'],
            );
          }).toList(),
        );
      } else {
        throw Exception('Failed to fetch order details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching order details: $error');
      rethrow;
    }
  }
}
class Order {
  final int orderId;
  final String orderStatus;
  final String orderPaymentStatus;
  final String orderPaymentMethod;
  final String orderAddress;
  final String shippingAddress;
  final String? phoneNumber; // Nullable phone number
  final String orderDate;
  final String orderPrice;
  final List<OrderDetail> orderDetail;

  Order({
    required this.orderId,
    required this.orderStatus,
    required this.orderAddress,
    required this.orderPaymentMethod,
    required this.orderPaymentStatus,
    required this.shippingAddress,
    required this.phoneNumber,
    required this.orderDate,
    required this.orderPrice,
    required this.orderDetail,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      orderStatus: json['order_status'] ?? '',
      orderPaymentStatus: json['payment_status'] ?? '',
      orderPaymentMethod: json['payment_type'] ?? '',
      orderAddress: json['order_address'] ?? '',
      shippingAddress: json['shipping_address'] ?? '',
      phoneNumber: json['phoneNumber'],
      orderDate: json['order_date'] ?? '',
      orderPrice: json['total_price'].toString(),
      orderDetail: (json['order_details'] as List<dynamic>).map((detail) => OrderDetail.fromJson(detail)).toList(),
    );
  }
}

class OrderDetail {
  final Product product;
  final int quantity;

  OrderDetail({
    required this.product,
    required this.quantity,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

class Product {
  final String productName;
  final double productPrice;
  final String productThumbnail;
  final Category category;
  final SubCategory subCategory;
  final Size size;

  Product({
    required this.productName,
    required this.productPrice,
    required this.productThumbnail,
    required this.category,
    required this.subCategory,
    required this.size,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['product_name'] ?? '',
      productPrice: double.parse(json['product_price'].toString()),
      productThumbnail: json['product_thumbnail'] ?? '',
      category: Category.fromJson(json['category']),
      subCategory: SubCategory.fromJson(json['sub_category']),
      size: Size.fromJson(json['size']),
    );
  }
}

class Category {
  final String categoryName;

  Category({
    required this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryName: json['category_name'] ?? '',
    );
  }
}

class SubCategory {
  final String subName;

  SubCategory({
    required this.subName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      subName: json['sub_name'] ?? '',
    );
  }
}

class Size {
  final String sizeName;

  Size({
    required this.sizeName,
  });

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      sizeName: json['size_name'] ?? '',
    );
  }
}
