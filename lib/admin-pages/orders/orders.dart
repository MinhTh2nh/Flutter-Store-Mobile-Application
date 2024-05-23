import 'package:flutter/material.dart';
import 'package:food_mobile_app/admin-pages/categories/small_components/category_form.dart';
import '../../components/slide_menu.dart';
import 'package:food_mobile_app/admin-pages/products/small_components/create_button.dart';
import '../../components/custome_app_bar/custom_app_bar_admin.dart';
import '../../model/cart_model.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'order_detail_page.dart';

class AdminOrderPage extends StatefulWidget {
  const AdminOrderPage({Key? key}) : super(key: key);

  static String routeName = "/admin/orders";

  @override
  _AdminOrderPageState createState() => _AdminOrderPageState();
}

class _AdminOrderPageState extends State<AdminOrderPage> {
  bool _isAscending = true; // Track sorting order
  String _filterByStatus = '';
  String? _selectedStatus;

  void updateOrderList() {
    Provider.of<CartModel>(context, listen: false).fetchOrders();
  }

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Provider.of<CartModel>(context, listen: false).fetchOrders();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Provider.of<CartModel>(context, listen: false).fetchOrders();
      }
    });
  }

  Color getStatusTileColor(String status) {
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


  void sortDataById(bool isAscending) {
    setState(() {
      _isAscending = isAscending;
      final cartModel = Provider.of<CartModel>(context, listen: false);
      cartModel.orders.sort((a, b) => isAscending
          ? a['order_id'].compareTo(b['order_id'])
          : b['order_id'].compareTo(a['order_id']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: SideMenu(),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    "List Of Orders",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  buttonAdmin(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryCreationForm(
                                onUpdate: updateOrderList)),
                      );
                    },
                    title: "NEW",
                    color: Colors.teal.shade200,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text('Status: '),
                      DropdownButton<String>(
                        value: _selectedStatus,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedStatus = newValue!;
                            _filterByStatus = _selectedStatus!;
                          });
                        },
                        items: <String>[
                          '',
                          'Pending',
                          'Delivering',
                          'Successful',
                          'Cancelled',
                          'Processing',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.isNotEmpty
                                ? value[0].toUpperCase() + value.substring(1)
                                : 'All'),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_upward),
                        onPressed: () => sortDataById(true), // Sort ascending
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () => sortDataById(false), // Sort descending
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            Consumer<CartModel>(
              builder: (context, cartModel, child) {
                if (cartModel.orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Oops, there are no orders",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          'lib/images/empty_shopping_cart_image.png',
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartModel.orders.length,
                  itemBuilder: (context, index) {
                    var order = cartModel.orders[index];
                    final status = order['order_status'] ?? '';
                    final tileColor = getStatusTileColor(status);

                    if (_filterByStatus.isNotEmpty &&
                        !status
                            .toLowerCase()
                            .contains(_filterByStatus.toLowerCase())) {
                      return SizedBox
                          .shrink(); // Hide item if not matching the filter
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: tileColor,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ID: ${order['order_id']}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Date: ${order['order_date'].substring(0, 10)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ), // Display first 10 characters
                                  Text(
                                    'Total price: ${order['total_price']}',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Status: ${order['order_status']}',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        _showOrderDetail(order['order_id'])
                                    ,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal.shade200,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text(
                                        'UPDATE',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        _deleteOrder(order['order_id']),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(0.0),
                                      child: Text(
                                        'DELETE',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetail(int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailPage(orderId: orderId, onUpdate: updateOrderList),
      ),
    );
  }

  void _deleteOrder(int orderId) async {
    // Implement the logic to delete the order
    final url = Uri.parse(
        'https://flutter-store-mobile-application-backend.onrender.com/orders/delete/$orderId');
    // Send delete request to your backend API
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Order deleted successfully
      // Show a snackbar or toast message to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order deleted successfully'),
        ),
      );
    } else {
      // Failed to delete order
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete order'),
        ),
      );
    }
  }

}
