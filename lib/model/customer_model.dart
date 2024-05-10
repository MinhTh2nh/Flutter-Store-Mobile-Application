import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomerModel {
  String email;
  String password;
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

      await storage.write(key: 'auth_token', value: token);
      await storage.write(key: 'email', value: email);

      return token;
    } else {
      return null;
    }
  }

  Future<void> logoutUser() async {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');
  }
}
