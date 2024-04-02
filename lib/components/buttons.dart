import 'package:flutter/material.dart';
import 'package:food_mobile_app/consts/consts.dart'; // Assuming red is defined here
import 'package:velocity_x/velocity_x.dart';

Widget buttons(String? title , {required VoidCallback onPress}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF0000FF), // Example color, replace with your desired color
      padding: const EdgeInsets.all(12),
    ),
    onPressed: () {
      onPress;
    },
    child: Text(
      title ?? '', // Use the title directly for the button text, with null check
      style: TextStyle(color: Colors.white), // Assuming you want white text color
    ),
  );
}
