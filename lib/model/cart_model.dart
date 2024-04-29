import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  List _shopItems = [];
  List _cartItems = [];

  CartModel() {
    _shopItems = [
      {
        "name": "Item 1",
        "itemPrice": "10.00",
        "imagePath":
            "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "in-stock": 4,
        "description":
            "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
                ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
      {
        "name": "Item 2",
        "itemPrice": "15.00",
        "imagePath":
            "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "in-stock": 5,
        "description":
            "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
                ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
      {
        "name": "Item 1",
        "itemPrice": "10.00",
        "imagePath":
            "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "in-stock": 4,
        "description":
            "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
                ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
      {
        "name": "Item 2",
        "itemPrice": "15.00",
        "imagePath":
            "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "in-stock": 5,
        "description":
            "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
                ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
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

  void addItemToCartWithQuantity(int index, int quantity) {
    // Create a copy of the item with the added quantity
    Map newItem = Map.from(_shopItems[index]);
    newItem['quantity'] = quantity;
    _cartItems.add(newItem);
    notifyListeners();
  }

  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  String calculateTotal() {
    double totalPrice = 0.0;
    for (var item in _cartItems) {
      totalPrice += double.parse(item['itemPrice']) * item['quantity'];
    }
    return totalPrice.toStringAsFixed(2);
  }
}
