import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  List _shopItems = [];
  List _cartItems = [];

  CartModel() {
    _shopItems = [
      {
        "name": "Item 1",
        "itemPrice": "10.00",
        "imagePath": "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "in-stock": 4 ,
      },
      {
        "name": "Item 2",
        "itemPrice": "15.00",
        "imagePath": "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg" ,
        "in-stock": 5 ,
      },
      // Add more static test data as needed
    ];
  }

  List get cartItems => _cartItems;
  List get shopItems => _shopItems;

  int get itemsCount => _cartItems.length;

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
      totalPrice += double.parse(item['itemPrice']); // Change 'price' to 'itemPrice'
    }
    return totalPrice.toStringAsFixed(2);
  }
}
