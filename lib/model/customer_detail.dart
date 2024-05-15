import 'dart:convert';
import 'package:http/http.dart' as http;
// import '../constants.dart';

class CustomerDetail {
  final int cdId;
  final int customerId;
  final String phone;
  final String address;

  CustomerDetail({
    required this.cdId,
    required this.customerId,
    required this.phone,
    required this.address,
  });

  factory CustomerDetail.fromJson(Map<String, dynamic> json) {
    return CustomerDetail(
      cdId: json['cd_id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
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

  static Future<void> updateAddress(
      int cdId, String phone, String address) async {
    final apiUrl =
        'https://flutter-store-mobile-application-backend.onrender.com/users/address/update/$cdId';

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
        'address': address,
      }),
    );

    if (response.statusCode == 200) {
      // Address updated successfully
    } else {
      throw Exception('Failed to update address: ${response.statusCode}');
    }
  }

  static Future<void> deleteAddress(int cdId) async {
    final apiUrl =
        'https://flutter-store-mobile-application-backend.onrender.com/users/address/delete/$cdId';

    final response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Address deleted successfully
    } else {
      throw Exception('Failed to delete address: ${response.statusCode}');
    }
  }
}
