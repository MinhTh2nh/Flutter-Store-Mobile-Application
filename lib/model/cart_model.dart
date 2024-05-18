// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  List _shopItems = [];
  final List _cartItems = [];
  List _productItems = [];
  List _categories = [];
  List _orders = [];
  List _searchResults = [];

  int _page = 1;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  CartModel() {
    fetchOrders();
    _shopItems = [];
    fetchCategories();
    fetchProducts();
  }

  List get cartItems => _cartItems;
  List get shopItems => _shopItems;
  List get categories => _categories;
  List get orders => _orders;
  List get productItems => _productItems;
  List get searchResults => _searchResults;

  int get itemsCount => _cartItems.length;

  Future<void> fetchProducts() async {
    if (_isLoading) return; // If a request is already in progress, do nothing

    _isLoading = true; // Set loading state to true
    try {
      // Make HTTP GET request to fetch products from API
      final response = await http.get(Uri.parse(
          'https://flutter-store-mobile-application-backend.onrender.com/products/get'));

      // Check if request is successful
      if (response.statusCode == 200) {
        // Decode JSON response body
        final List<dynamic> products = json.decode(response.body)['data'];

        // Update _shopItems with fetched products
        _shopItems = products;
        // Print fetched products
        // print('Fetched products: $_shopItems');

        // Notify listeners of the change
        notifyListeners();

        _page++; // Increment the page number for the next request
      } else {
        // Handle error response
        print('Failed to fetch products: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Network error: $error');
    } finally {
      _isLoading = false; // Set loading state to false
    }
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse(
        'https://flutter-store-mobile-application-backend.onrender.com/products/get/category/categoryList');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> categories = json.decode(response.body)['data'];
        _categories = categories;
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://flutter-store-mobile-application-backend.onrender.com/orders/get');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> orders = json.decode(response.body)['data'];
        _orders = orders;
        print(orders);
        notifyListeners(); // Notify listeners after updating the orders list
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }

  Future<void> fetchProductItems(int productId) async {
    if (_isLoading) return; // If a request is already in progress, do nothing

    _isLoading = true; // Set loading state to true
    try {
      // Make HTTP GET request to fetch product items from API
      final response = await http.get(Uri.parse(
          'https://flutter-store-mobile-application-backend.onrender.com/products/get/itemList/$productId'));

      // Check if request is successful
      if (response.statusCode == 200) {
        // Decode JSON response body
        final List<dynamic> productItems = json.decode(response.body)['data'];
        // Update _productItems with fetched product items
        _productItems = productItems;

        // Notify listeners of the change
        notifyListeners();
      } else {
        // Handle error response
        print('Failed to fetch product items: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Network error: $error');
    } finally {
      _isLoading = false; // Set loading state to false
    }
  }

  Future<void> search(String query) async {
    if (_isLoading) return;

    _isLoading = true;
    try {
      await Future.delayed(const Duration(seconds: 1));

      _searchResults = _mockSearch(query);

      notifyListeners();
    } catch (error) {
      print('Error searching: $error');
    } finally {
      _isLoading = false;
    }
  }

  List<String> _mockSearch(String query) {
    List<String> allItems =
        _shopItems.map((item) => item['product_name'].toString()).toList();
    return allItems
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void addItemToCartWithQuantity(
      int itemId, int quantity, String selectedSize, int productId) {
    // Find the product with the matching item_id
    var item = _productItems.firstWhere(
        (element) => element['item_id'] == itemId,
        orElse: () => null);

    // Check if item is null (no matching element found)
    if (item != null) {
      // Find the product details based on the provided product_id
      var product = _shopItems.firstWhere(
          (element) => element['product_id'] == productId,
          orElse: () => null);

      // Check if product is null (no matching element found)
      if (product != null) {
        // Create a copy of the product with the added details
        Map newItem = {
          'item_id': itemId,
          'product_id': product['product_id'],
          'product_name': product['product_name'],
          'product_price': product['product_price'],
          'product_thumbnail': product['product_thumbnail'],
          'quantity': quantity,
          'selectedSize': item["size_name"],
        };

        // Add the new item to cart
        _cartItems.add(newItem);
        notifyListeners();
      } else {
        print('No product found with product_id: $productId');
      }
    } else {
      print('No item found with item_id: $itemId');
    }
  }

  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _cartItems[index]['quantity']++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity']--;
    } else {
      // If quantity is 1, remove the item from the cart
      removeItemFromCart(index);
    }
    notifyListeners();
  }

  String calculateTotal() {
    double totalPrice = 0.0;
    for (var item in _cartItems) {
      totalPrice +=
          double.parse(item['product_price'].toString()) * item['quantity'];
    }
    return totalPrice.toStringAsFixed(2);
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }
}
