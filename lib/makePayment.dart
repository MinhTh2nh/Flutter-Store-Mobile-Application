import 'package:flutter/material.dart';
import 'PaypalPayment.dart';
import 'model/order_model.dart';

void startPaypalPayment(BuildContext context, Order order, Function(String) onFinish) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) => PaypalPayment(
        order: order,
        onFinish: onFinish,
      ),
    ),
  );
}
