import 'package:flutter/material.dart';
import 'package:food_mobile_app/pages/sign_in/sign_in.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../components/buttons.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/form_error.dart';
import '../../../consts/consts.dart';
import '../../complete_profile/complete_profile_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  bool isCheck = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  bool remember = false;
  final List<String?> errors = [];


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
          SizedBox(height: 20),
          CustomTextField(
            hint: emailHint,
            title: email,
            controller: emailController,
            isPass: true,
            suffixIcon: CustomSurffixIcon(svgIcon: "/icons/Mail.svg"),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          SizedBox(height: 10),
          CustomTextField(
            hint: passwordHint,
            title: password,
            controller: passwordController,
            isPass: true,
            suffixIcon: CustomSurffixIcon(svgIcon: "/icons/Lock.svg"),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          SizedBox(height: 10),
          CustomTextField(
            hint: passwordHint,
            title: passwordConfirm,
            controller: passwordRetypeController,
            isPass: true,
            suffixIcon: CustomSurffixIcon(svgIcon: "/icons/Lock.svg"),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          SizedBox(height: 10),
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
              SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
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
              if (
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
              if (!isCheck) {
                VxToast.show(context, msg: "Please agree to the Terms and Conditions.");
                return;
              }
            },
          ).box.width(context.screenWidth - 50).make(),
        ],
      ),
    );
  }
}