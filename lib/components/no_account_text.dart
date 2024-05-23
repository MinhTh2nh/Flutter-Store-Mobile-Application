import 'package:flutter/material.dart';
import '../pages/sign_up/sign_up.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don’t have an account? ",
          style: TextStyle(fontSize: 16),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 16, color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }
}