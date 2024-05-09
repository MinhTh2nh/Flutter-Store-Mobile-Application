import 'package:flutter/material.dart';

Widget buttonAdmin({
  required String title,
  required Color color,
  required Color textColor,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(
        title,
        style: TextStyle(color: textColor, fontSize: 20),
      ),
    ),
  );
}
