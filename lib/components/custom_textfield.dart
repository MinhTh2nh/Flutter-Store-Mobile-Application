import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? title;
  final String? hint;
  final TextEditingController? controller;
  final bool isPass;
  final Widget? suffixIcon;
  final FloatingLabelBehavior? floatingLabelBehavior;

  const CustomTextField({
    super.key,
    this.title,
    this.hint,
    this.controller,
    this.isPass = false,
    this.suffixIcon,
    this.floatingLabelBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                  obscureText: isPass,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    isDense: true,
                    filled: false,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, // Adjust border color as needed
                        width: 1, // Adjust border thickness as needed
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red, // Adjust border color as needed
                        width: 2, // Adjust border thickness as needed
                      ),
                    ),
                    floatingLabelBehavior: floatingLabelBehavior,
                  ),
                ),
              ),
              if (suffixIcon != null) suffixIcon!,
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
