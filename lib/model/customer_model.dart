import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants.dart';

class CustomerModel {
  String email;
  String password;
  String? token;
  Map<String, dynamic>? userData;
  final storage = const FlutterSecureStorage();

  CustomerModel({required this.email, required this.password});

  Future<String?> loginUser() async {
    const String apiUrl =
        'https://flutter-store-mobile-application-backend.onrender.com/users/login';

    final response = await http.post(Uri.parse(apiUrl), body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      String token = data['token'];
      userData = data['user'];
      globalCustomerId = userData?['customer_id'];
      globalUserName = userData?['name'];

      // String encodedToken = base64.encode(utf8.encode(token));

      await storage.write(key: 'auth_token', value: token);
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'user_data', value: json.encode(userData));

      return token;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    String? userDataString = await storage.read(key: 'user_data');
    if (userDataString != null) {
      return json.decode(userDataString);
    } else {
      return null;
    }
  }

  // Future<String> getName() async {
  //   String? userDataString = await storage.read(key: 'user_data');
  //   if (userDataString != null) {
  //     Map<String, dynamic> userData = json.decode(userDataString);
  //     String name = userData['name'];
  //     return name;
  //   } else {
  //     return '';
  //   }
  // }

  // Future<int?> getCustomerId() async {
  //   String? userDataString = await storage.read(key: 'user_data');
  //   if (userDataString != null) {
  //     Map<String, dynamic> userData = json.decode(userDataString);
  //     int? customerId = userData['customer_id'];
  //     return customerId;
  //   } else {
  //     return null;
  //   }
  // }

  Future<void> logoutUser() async {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');
    await storage.delete(key: 'user_data');
    token = null;
    userData = null;
  }
}
