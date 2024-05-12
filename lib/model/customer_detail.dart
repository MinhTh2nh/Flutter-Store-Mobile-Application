import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class CustomerDetail {
  final String phone;
  final String address;

  CustomerDetail({required this.phone, required this.address});

  factory CustomerDetail.fromJson(Map<String, dynamic> json) {
    return CustomerDetail(
      phone: json['phone'],
      address: json['address'],
    );
  }

  static Future<List<CustomerDetail>> fetchAddress(int customerId) async {
    final apiUrl =
        'https://flutter-store-mobile-application-backend.onrender.com/users/address/get/$customerId';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('data') && data['data'] is List<dynamic>) {
        List<dynamic> addressData = data['data'];
        return addressData
            .map((json) => CustomerDetail.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load address: Invalid data format');
      }
    } else {
      throw Exception('Failed to load address: ${response.statusCode}');
    }
  }

    static Future<void> createAddress(
      String phone, String address, int customerId) async {
    const apiUrl =
        'https://flutter-store-mobile-application-backend.onrender.com/users/address/create';

    final response = await http.post(Uri.parse(apiUrl), body: {
      'customer_id': customerId.toString(),
      'phone': phone,
      'address': address,
    });

    if (response.statusCode == 200) {
      // Address created successfully
    } else {
      throw Exception('Failed to create address: ${response.statusCode}');
    }
  }
}
