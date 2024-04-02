import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:food_mobile_app/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';

Widget customeTextField({String? title, String? hint, controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(Colors.red).size(15).make(),
      5.heightBox,
      TextFormField(
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: Colors.lightGreen,
          filled: true,
          border: InputBorder.none,
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        ),
      ),
      5.heightBox,
    ],
  );
}
