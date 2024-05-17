import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../components/buttons.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/form_error.dart';
import '../../../consts/consts.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  bool isCheck = false;
  bool isPass = true;

  final storage = const FlutterSecureStorage();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  bool remember = false;
  final List<String?> errors = [];

  void togglePasswordVisibility() {
    setState(() {
      isPass = !isPass;
    });
  }

  Future<void> registerUser() async {
    setState(() {
      isLoading = true; // Show loading indicator when registering
    });

    try {
      const String apiUrl =
          'https://flutter-store-mobile-application-backend.onrender.com/users/register';
      final response = await http.post(
        Uri.parse('$apiUrl'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        String token = data['token'];
        await storage.write(key: 'auth_token', value: token);
        await storage.write(key: 'email', value: emailController.text);
        await storage.write(key: 'password', value: passwordController.text);
        Navigator.pushReplacementNamed(context, '/sign_in');
      } else {
        print('Error response body: ${response.body}');
        print('Error response status code: ${response.statusCode}');
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during registration: $e');
      throw Exception('Failed to register: $e');
    }
    setState(() {
      isLoading = false; // Hide loading indicator after registration attempt
    });
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hint: nameHint,
            title: name,
            controller: nameController,
            isPass: false,
            suffixIcon: const Icon(
              Icons.person,
              size: 16,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hint: emailHint,
            title: email,
            controller: emailController,
            isPass: false,
            suffixIcon: const Icon(
              Icons.mail,
              size: 16,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hint: passwordHint,
            title: password,
            controller: passwordController,
            isPass: true,
            suffixIcon: GestureDetector(
              // Wrap the Icon with GestureDetector
              onTap:
                  togglePasswordVisibility, // Call togglePasswordVisibility method
              child: Icon(
                isPass
                    ? Icons.lock
                    : Icons.lock_open, // Change icon based on isPass value
                size: 16,
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            hint: passwordHint,
            title: passwordConfirm,
            controller: passwordRetypeController,
            isPass: true,
            suffixIcon: GestureDetector(
              // Wrap the Icon with GestureDetector
              onTap:
                  togglePasswordVisibility, // Call togglePasswordVisibility method
              child: Icon(
                isPass
                    ? Icons.lock
                    : Icons.lock_open, // Change icon based on isPass value
                size: 16,
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                checkColor: Colors.red,
                value: isCheck,
                onChanged: (newValue) {
                  setState(() {
                    isCheck = newValue!;
                  });
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: "I agree to the ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: "Terms and Conditions",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          FormError(errors: errors),
          const SizedBox(height: 16),
          buttons(
            color: isCheck ? Colors.red : Colors.grey,
            title: "Sign Up",
            textColor: Colors.white,
            onPress: () async {
              if (!isCheck) {
                VxToast.show(context,
                    msg: "Please agree to the Terms and Conditions.");
                return; // Prevent sign-up action if terms are not agreed
              }
              if (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  passwordController.text.isEmpty ||
                  passwordRetypeController.text.isEmpty) {
                VxToast.show(context, msg: "Please fill in all fields.");
                return;
              }
              if (passwordController.text != passwordRetypeController.text) {
                VxToast.show(context, msg: "Passwords do not match.");
                return;
              }
              // Call registerUser function here
              registerUser();
            },
          ).box.width(context.screenWidth - 50).make(),
        ],
      ),
    );
  }
}
