import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  List _shopItems = [];
  List _cartItems = [];
  List _productItems = [];
  int _page = 1;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  CartModel() {
    _shopItems = [];
    _productItems = [
      {"item_id": 0, "product_id": 1, "stock": 5, "size": "XS-MS"},
      {"item_id": 1, "product_id": 1, "stock": 5, "size": "M-XM"},
      {"item_id": 2, "product_id": 1, "stock": 5, "size": "L-XL"},
      {"item_id": 3, "product_id": 1, "stock": 5, "size": "XXL-XXXL"},
    ];

    fetchProducts();
  }

  List get cartItems => _cartItems;
  List get shopItems => _shopItems;
  List get productItems => _productItems;

  int get itemsCount => _cartItems.length;

  void fetchProducts() async {
    if (_isLoading) return; // If a request is already in progress, do nothing

    _isLoading = true; // Set loading state to true
    try {
      // Make HTTP GET request to fetch products from API
      final response = await http
          .get(Uri.parse('http://192.168.1.12:8081/products/getAllProducts'));

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

  void addItemToCartWithQuantity(
      int item_id, int quantity, String selectedSize, int product_id) {
    // Find the product with the matching item_id
    var item = _productItems.firstWhere(
        (element) => element['item_id'] == item_id,
        orElse: () => null);

    // Check if item is null (no matching element found)
    if (item != null) {
      // Find the product details based on the provided product_id
      var product = _shopItems.firstWhere(
          (element) => element['product_id'] == product_id,
          orElse: () => null);

      // Check if product is null (no matching element found)
      if (product != null) {
        // Create a copy of the product with the added details
        Map newItem = {
          'item_id': item_id,
          'product_id': product['product_id'],
          'product_name': product['product_name'],
          'product_price': product['product_price'],
          'product_thumbnail': product['product_thumbnail'],
          'quantity': quantity,
          'selectedSize': item["size"],
        };

        // Add the new item to cart
        _cartItems.add(newItem);
        notifyListeners();
      } else {
        print('No product found with product_id: $product_id');
      }
    } else {
      print('No item found with item_id: $item_id');
    }
  }

  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
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
}
