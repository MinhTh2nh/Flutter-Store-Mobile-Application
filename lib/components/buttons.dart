import 'package:flutter/material.dart';

Widget buttons({
  required String title,
  required Color color,
  required Color textColor,
  required VoidCallback onPress,
})
{
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),
    onPressed: onPress, // Use onPressed instead of onTap
    child: Text(
      title,
      style: TextStyle(color: textColor),
    ),
  );
}
