import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_mobile_app/components/buttons.dart';
import 'package:food_mobile_app/components/custom_textfield.dart';
import 'package:food_mobile_app/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'package:food_mobile_app/pages/login.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

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
                "Join to the $appName",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                // Add horizontal padding
                child: Column(
                  children: [
                    customeTextField(
                      hint: nameHint,
                      title: name,
                    ),
                    SizedBox(height: 20),
                    //
                    customeTextField(
                      hint: emailHint,
                      title: email,
                    ),
                    SizedBox(height: 10),
                    // Add some space between text fields
                    customeTextField(
                      hint: passwordHint,
                      title: password,
                    ),
                    SizedBox(height: 10),
                    // Add some space between text fields
                    customeTextField(
                      hint: passwordConfirm,
                      title: password,
                    ),
                    SizedBox(height: 20),
                    // Add more space after text fields
                    Row(
                      children: [
                        Checkbox(
                            checkColor: Colors.red,
                            value: false,
                            onChanged: (newValue) {}),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: "I agree to the ",
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            TextSpan(
                                text: "Terms and Conditions",
                                style: TextStyle(
                                  color: Colors.red,
                                )),
                          ])),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    // Add more space after text fields
                    buttons("Sign Up", onPress: () {})
                        .box
                        .width(context.screenWidth - 50)
                        .make(),
                    SizedBox(height: 20),
                    // Add more space after text fields
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: "Having an Account ?".text.make(),
                          ),
                          buttons("Login", onPress: () {
                            Get.to(() => const LoginPage());
                          }),
                        ],
                      ),
                    ),
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
