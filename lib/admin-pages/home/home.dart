import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_mobile_app/admin-pages/orders/orders.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../components/slide_menu.dart';
import '../../components/custome_app_bar/custom_app_bar_admin.dart';
import '../../model/cart_model.dart';
import '../products/products.dart';
import 'small_components/overall_portfolio_card.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);
  static String routeName = "/admin";

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final ScrollController scrollController = ScrollController();
  List<dynamic> _userLists = [];
  List<dynamic> _orderLists = [];
  double _estimatedRevenue = 0.0;
  double _realRevenue = 0.0;
  bool _isLoading = true;

  final String pathUser =
      "https://flutter-store-mobile-application-backend.onrender.com/users/get";
  final String pathOrder =
      "https://flutter-store-mobile-application-backend.onrender.com/orders/get";

  @override
  void initState() {
    super.initState();
    fetchData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // Assuming CartModel fetchProducts method is defined correctly.
        Provider.of<CartModel>(context, listen: false).fetchProducts();
      }
    });
  }

  Future<void> fetchData() async {
    await Future.wait([fetchCustomers(), fetchOrders()]);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchCustomers() async {
    final url = Uri.parse(pathUser);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> listCustomers = json.decode(response.body)['data'];
        setState(() {
          _userLists = listCustomers;
        });
      } else {
        throw Exception('Failed to fetch customers: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching customers: $error');
    }
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(pathOrder);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> listOrders = json.decode(response.body)['data'];
        setState(() {
          _orderLists = listOrders;
          _calculateEstimatedRevenue();
          _calculateRealRevenue();
        });
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }

  void _calculateEstimatedRevenue() {
    double total = 0.0;
    for (var order in _orderLists) {
      if (order['order_status'] != 'cancelled') {
        total += order['total_price'];
      }
    }
    setState(() {
      _estimatedRevenue = total;
    });
  }

  void _calculateRealRevenue() {
    double total = 0.0;
    for (var order in _orderLists) {
      if (order['order_status'] == 'successed') {
        total += order['total_price'];
      }
    }
    setState(() {
      _realRevenue = total;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: SideMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            SizedBox(height: 10),
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Consumer<CartModel>(
                      builder: (context, cartModel, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Shop Items',
                                style: TextStyle(color: Colors.redAccent)),
                            Text('${cartModel.shopItems.length}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 34.0)),
                          ],
                        );
                      },
                    ),
                    Material(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(24.0),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.store,
                              color: Colors.white, size: 30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onPress: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => AdminProductPage())),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Customers',
                                  style: TextStyle(color: Colors.redAccent)),
                              Text('${_userLists.length}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0)),
                            ],
                          ),
                          Material(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.people,
                                    color: Colors.white, size: 30.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPress: () {
                      // Add your navigation logic here for Customers
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Total Orders',
                                  style: TextStyle(color: Colors.redAccent)),
                              Text('${_orderLists.length}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0)),
                            ],
                          ),
                          Material(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Icon(Icons.shopping_cart,
                                    color: Colors.white, size: 30.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPress: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => AdminOrderPage())),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            OverallPortfolioCard(
                estimatedRevenue: _estimatedRevenue, realRevenue: _realRevenue),
            SizedBox(height: 20),
            _buildTile(
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Text(
                            'Summary Products',
                            style: TextStyle(
                              fontSize: 26.0,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ), onPress: () {  }
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildBarChart(context),
                ],
              ),
            ),
            SizedBox(width: 16), // Add some space between the two columns
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By Sub-Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildBarChart2(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(
      double value, TitleMeta meta, List<String> categories) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    Widget text;
    if (value.toInt() < categories.length) {
      text = Text(categories[value.toInt()], style: style);
    } else {
      text = const Text('', style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: text,
    );
  }

// Function to generate widgets for left titles
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    return Text(value.toInt().toString(),
        style: style, textAlign: TextAlign.left);
  }

  Widget _buildBarChart(BuildContext context) {
    final categoryOrders = _calculateCategoryOrders(context);

    final List<String> categories = categoryOrders.keys.toList();
    final List<int> orders = categoryOrders.values.toList();

    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          barGroups: List.generate(categories.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: orders[index].toDouble(),
                  color: Colors.blue,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    bottomTitleWidgets(value, meta, categories),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 42,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black, width: 1),
          ),
          minY: 0,
          maxY: orders.reduce((a, b) => a > b ? a : b).toDouble() +
              1, // Add padding to the max Y value
        ),
      ),
    );
  }

  Widget _buildBarChart2(BuildContext context) {
    final categoryOrders = _calculateCategoryOrders2(context);

    final List<String> categories = categoryOrders.keys.toList();
    final List<int> orders = categoryOrders.values.toList();

    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          barGroups: List.generate(categories.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: orders[index].toDouble(),
                  color: Colors.blue,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    bottomTitleWidgets(value, meta, categories),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: leftTitleWidgets,
                reservedSize: 42,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black, width: 1),
          ),
          minY: 0,
          maxY: orders.reduce((a, b) => a > b ? a : b).toDouble() +
              1, // Add padding to the max Y value
        ),
      ),
    );
  }

  Map<String, int> _calculateCategoryOrders(BuildContext context) {
    Map<String, int> categoryOrders = {};

    // Count orders per category
    for (var item in Provider.of<CartModel>(context, listen: false).shopItems) {
      String categoryName = item['category_name'];
      categoryOrders[categoryName] = (categoryOrders[categoryName] ?? 0) + 1;
    }

    return categoryOrders;
  }

  Map<String, int> _calculateCategoryOrders2(BuildContext context) {
    Map<String, int> categoryOrders = {};

    // Count orders per category
    for (var item in Provider.of<CartModel>(context, listen: false).shopItems) {
      String categoryName = item['sub_name'];
      categoryOrders[categoryName] = (categoryOrders[categoryName] ?? 0) + 1;
    }

    return categoryOrders;
  }

  Widget _buildTile(Widget child, {required VoidCallback onPress}) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
        onTap: onPress,
        child: child,
      ),
    );
  }
}
