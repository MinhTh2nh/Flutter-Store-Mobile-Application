import 'package:flutter/material.dart';
import 'package:food_mobile_app/components/buttons.dart';
import 'package:food_mobile_app/components/custom_textfield.dart';
import 'package:food_mobile_app/consts/consts.dart';
import 'package:food_mobile_app/pages/signup.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Setting background color
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView to avoid overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Text(
                "Login into $appName",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                // Add horizontal padding
                child: Column(
                  children: [
                    customeTextField(
                      hint: emailHint,
                      title: email,
                      isPass: false,
                    ),
                    SizedBox(height: 10), // Add some space between text fields
                    customeTextField(
                      hint: passwordHint,
                      title: password,
                      isPass: true,
                    ),
                    SizedBox(height: 20), // Add more space after text fields
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {}, child: forgetPass.text.make()),
                    ),
                    SizedBox(height: 10), // Add more space after text fields
                    buttons(
                            title: "Login",
                            color: Colors.red,
                            textColor: Colors.white, // Text color set to black
                            onPress: () {})
                        .box
                        .width(context.screenWidth - 50)
                        .make(),
                    SizedBox(height: 10), // Add more space after text fields
                    createNewAccount.text.color(Colors.grey).make(),
                    buttons(
                        title: "Sign Up",
                        color: Colors.transparent,
                        textColor: Colors.red, // Text coext color set to black,
                        onPress: () {
                          Get.to(() => const SignupPage());
                        }).box.width(context.screenWidth - 50).make(),
                    SizedBox(height: 10), // Add more space after text fields
                    SizedBox(height: 10), // Add more space after text fields
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
