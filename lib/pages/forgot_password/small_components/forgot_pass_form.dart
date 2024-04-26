import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../components/buttons.dart';
import '../../../consts/consts.dart';
import '../../../components/custom_surfix_icon.dart';
import '../../../components/custom_textfield.dart';
import '../../../components/form_error.dart';
import '../../../components/no_account_text.dart';
import '../../../consts/consts.dart';

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  var emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];

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
            suffixIcon: CustomSurffixIcon(svgIcon: "/icons/Mail.svg"),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          const SizedBox(height: 8),
          FormError(errors: errors),
          const SizedBox(height: 8),
          buttons(
              title: "Continue",
              color: Colors.red,
              textColor: Colors.white, // Text color set to black
              onPress: () {})
              .box
              .width(context.screenWidth - 50)
              .make(),
          const SizedBox(height: 16),
          const NoAccountText(),
        ],
      ),
    );
  }
}
