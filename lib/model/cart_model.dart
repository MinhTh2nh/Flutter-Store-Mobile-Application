import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List _shopItems = const [
    ["Enjoy the New Year", "12.00", "lib/images/shirt1.jpg"],
    ["Have a Nice Daisy", "11.00", "lib/images/shirt2.jpg"],
    ["Year Of The Dragon", "11.00", "lib/images/shirt3.jpg"],
    ["72 My Hometown", "11.00", "lib/images/shirt4.jpg"],
  ];

  List _cartItems = [];

  get cartItems => _cartItems;
  get shopItems => _shopItems;

  void addItemToCart(int index) {
    _cartItems.add(_shopItems[index]);
    notifyListeners();
  }

  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  String calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalPrice += double.parse(cartItems[i][1]);
    }
    return totalPrice.toStringAsFixed(2);
  }
}
