import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  List _shopItems = [];
  List _cartItems = [];
  List _productItems = [];

  CartModel() {
    _shopItems = [
      {
        "product_id" : 1 ,
        "name": "Product 1",
        "itemPrice": "10.00",
        "imagePath":
            "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "totalStock": 4,
        "description":
            "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
                ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
      {
        "product_id" : 2,
        "name": "Product 2",
        "itemPrice": "15.00",
        "imagePath":
            "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "totalStock": 4,
        "description":
            "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
                ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
      {
        "product_id" : 3,
        "name": "Product 3",
        "itemPrice": "10.00",
        "imagePath":
            "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "totalStock": 4,
        "description":
            "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
                ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
      {
        "product_id" : 4,
        "name": "Product 4",
        "itemPrice": "15.00",
        "imagePath":
            "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "totalStock": 4,
        "description":
            "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
                ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
      {
        "product_id" : 5,
        "name": "Product 5",
        "itemPrice": "10.00",
        "imagePath":
        "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "totalStock": 4,
        "description":
        "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
            ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
      {
        "product_id" : 6,
        "name": "Product 6",
        "itemPrice": "15.00",
        "imagePath":
        "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "totalStock": 4,
        "description":
        "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
            ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
      {
        "product_id" : 7,
        "name": "Product 7",
        "itemPrice": "10.00",
        "imagePath":
        "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "totalStock": 4,
        "description":
        "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
            ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
      {
        "product_id" : 8,
        "name": "Product 8",
        "itemPrice": "15.00",
        "imagePath":
        "https://gamek.mediacdn.vn/133514250583805952/2021/5/1/photo-1-16198832601821648986883.jpg",
        "totalStock": 4,
        "description":
        "orem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages"
            ", and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
      },
    ];
    _productItems = [
      {
        "item_id" : 0 ,
        "product_id" : 1 ,
        "stock" : 5 ,
        "size" : "XS-MS"
      },
      {
        "item_id" : 1 ,
        "product_id" : 1 ,
        "stock" : 5 ,
        "size" : "M-XM"
      },
      {
        "item_id" : 2 ,
        "product_id" : 1 ,
        "stock" : 5 ,
        "size" : "L-XL"
      },
      {
        "item_id" : 3 ,
        "product_id" : 1 ,
        "stock" : 5 ,
        "size" : "XXL-XXXL"
      },
      {
        "item_id" : 4 ,
        "product_id" : 1 ,
        "stock" : 5 ,
        "size" : "XXS-S"
      },
    ];

  }

  List get cartItems => _cartItems;
  List get shopItems => _shopItems;
  List get productItems => _productItems;

  int get itemsCount => _cartItems.length;


  void addItemToCartWithQuantity(int item_id, int quantity, String selectedSize, int product_id) {
    // Find the product with the matching item_id
    var item = _productItems.firstWhere((element) => element['item_id'] == item_id, orElse: () => null);

    // Check if item is null (no matching element found)
    if (item != null) {
      // Find the product details based on the provided product_id
      var product = _shopItems.firstWhere((element) => element['product_id'] == product_id, orElse: () => null);

      // Check if product is null (no matching element found)
      if (product != null) {
        // Create a copy of the product with the added details
        Map newItem = {
          'item_id': item_id,
          'product_id': product['product_id'],
          'name': product['name'],
          'itemPrice': product['itemPrice'],
          'imagePath': product['imagePath'],
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
      totalPrice += double.parse(item['itemPrice']) * item['quantity'];
    }
    return totalPrice.toStringAsFixed(2);
  }
}
