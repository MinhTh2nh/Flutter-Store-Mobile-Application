import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_mobile_app/components/buttons.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../admin-pages/home/home.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../consts/consts.dart';
import '../../../model/customer_model.dart';
import '../../forgot_password/forgot_password.dart';
import '../../../components/custom_textfield.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  bool? remember = false;

  final storage = const FlutterSecureStorage();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final List<String?> errors = [];

  @override
  void initState() {
    super.initState();
    _getSavedCredentials();
  }

  // Method to retrieve saved email and password
  Future<void> _getSavedCredentials() async {
    final email = await storage.read(key: 'email');
    final password = await storage.read(key: 'password');

    if (email != null && password != null) {
      setState(() {
        emailController.text = email;
        passwordController.text = password;
        remember = true;
      });
    }
  }

    // Method to save email and password if remember me is checked
  Future<void> _saveCredentials() async {
    if (remember ?? false) {
      await storage.write(key: 'email', value: emailController.text);
      await storage.write(key: 'password', value: passwordController.text);
    }
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

  Future<void> loginUser() async {
    final customer = CustomerModel(
      email: emailController.text,
      password: passwordController.text,
    );

    final token = await customer.loginUser();
    if (token != null) {
      // Store the token securely, for example in SharedPreferences
      // Here, we'll just print it for demonstration purposes

      // Navigate to the next screen after successful login
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Handle login failure
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content:
                const Text('Incorrect email or password. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            hint: emailHint,
            title: email,
            controller: emailController,
            isPass: false,
            suffixIcon: const CustomSurffixIcon(svgIcon: "/icons/Mail.svg"),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),

          const SizedBox(height: 20),

          CustomTextField(
            hint: passwordHint,
            title: password,
            controller: passwordController,
            isPass: false,
            suffixIcon: const CustomSurffixIcon(svgIcon: "/icons/Lock.svg"),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value!;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          const SizedBox(height: 16),
          buttons(
              title: "Login",
              color: Colors.red,
              textColor: Colors.white, // Text color set to white
              onPress: () async {
                await _saveCredentials();
                // Check if email and password match the admin credentials
                if (emailController.text == "admin@gmail.com" &&
                    passwordController.text == "testingdemo") {
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, AdminHomePage.routeName);
                } else if (_formKey.currentState!.validate()) {
                  // Navigate to regular home page if credentials don't match
                  await loginUser();
                }
              }).box.width(context.screenWidth - 50).make(),

          const SizedBox(height: 10), // Add more s
        ],
      ),
    );
  }
}
