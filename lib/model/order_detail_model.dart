import 'dart:convert';
import 'package:http/http.dart' as http;

class Order {
  final int orderId;
  final DateTime orderDate;
  final String orderStatus;
  final double totalPrice;
  final List<OrderDetail> orderDetails;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.orderStatus,
    required this.totalPrice,
    required this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'],
      orderDate: DateTime.parse(json['order_date']),
      orderStatus: json['order_status'],
      totalPrice: json['total_price'].toDouble(),
      orderDetails: List<OrderDetail>.from(
          json['order_details'].map((detail) => OrderDetail.fromJson(detail))),
    );
  }

  //   static Future<List<Order>> fetchOrdersByCustomerId(int customerId) async {
  //   final response = await http.get(
  //       'https://flutter-store-mobile-application-backend.onrender.com/orders/get/customer/$customerId' as Uri);

  //   if (response.statusCode == 200) {
  //     final List<Order> orders = [];
  //     final List<dynamic> responseData = json.decode(response.body)['data'];
  //     for (var orderData in responseData) {
  //       orders.add(Order.fromJson(orderData));
  //     }
  //     return orders;
  //   } else {
  //     throw Exception('Failed to load orders');
  //   }
  // }
}

class OrderDetailModel {
  Future<List<Order>> fetchOrdersByCustomerId(int customerId) async {
    final apiUrl =
        'https://flutter-store-mobile-application-backend.onrender.com/orders/get/customer/$customerId';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<Order> orders = [];
      final List<dynamic> responseData = json.decode(response.body)['data'];
      for (var orderData in responseData) {
        orders.add(Order.fromJson(orderData));
      }
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return orders;
    } else {
      throw Exception('Failed to load orders');
    }
  }
}

class OrderDetail {
  final int detailId;
  final int quantity;
  final Product product;

  OrderDetail({
    required this.detailId,
    required this.quantity,
    required this.product,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      detailId: json['detail_id'],
      quantity: json['quantity'],
      product: Product.fromJson(json['product']),
    );
  }
}

class Product {
  final int productId;
  final String productName;
  final double productPrice;
  final String productThumbnail;
  final String productDescription;
  final Category category;
  final SubCategory subCategory;
  final Size size;
  final int stock;

  Product({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productThumbnail,
    required this.productDescription,
    required this.category,
    required this.subCategory,
    required this.size,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      productPrice: json['product_price'].toDouble(),
      productThumbnail: json['product_thumbnail'],
      productDescription: json['product_description'],
      category: Category.fromJson(json['category']),
      subCategory: SubCategory.fromJson(json['sub_category']),
      size: Size.fromJson(json['size']),
      stock: json['stock'],
    );
  }
}

class Category {
  final int categoryId;
  final String categoryName;

  Category({
    required this.categoryId,
    required this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
    );
  }
}

class SubCategory {
  final int subId;
  final String subName;

  SubCategory({
    required this.subId,
    required this.subName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      subId: json['sub_id'],
      subName: json['sub_name'],
    );
  }
}

class Size {
  final int sizeId;
  final String sizeName;

  Size({
    required this.sizeId,
    required this.sizeName,
  });

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      sizeId: json['size_id'],
      sizeName: json['size_name'],
    );
  }
}
