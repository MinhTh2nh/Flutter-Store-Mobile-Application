import 'package:flutter/material.dart';
import 'package:food_mobile_app/consts/consts.dart'; // Assuming red is defined here
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter/material.dart';

Widget buttons({
  required String title,
  required Color color,
  required Color textColor,
  required VoidCallback onPress,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.all(12),
    ),
    onPressed: onPress,
    child: Text(
      title,
      style: TextStyle(color: textColor),
    ),
  );
}
