import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List _shopItems = [];
  List _cartItems = [];

  CartModel() {
    fetchShopItems();
  }

  List get cartItems => _cartItems;
  List get shopItems => _shopItems;

  int get itemsCount => _cartItems.length;

  // Fetch shop items from Firestore
  void fetchShopItems() async {
    try {
      var querySnapshot = await _firestore.collection('products').get();
      _shopItems = querySnapshot.docs.map((doc) => {
        "name": doc['name'],
        "itemPrice": doc['price'].toString(),
        "imagePath": doc['imageUrl']
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void addItemToCart(int index) {
    _cartItems.add(_shopItems[index]);
    notifyListeners();
  }

  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  String calculateTotal() {
    double totalPrice = 0.0;
    for (var item in _cartItems) {
      totalPrice += double.parse(item['price']);
    }
    return totalPrice.toStringAsFixed(2);
  }
}
