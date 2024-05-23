import 'package:flutter/material.dart';
import 'package:food_mobile_app/pages/sign_in/sign_in.dart';
import 'package:food_mobile_app/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:food_mobile_app/model/cart_model.dart';
import 'consts/consts.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        initialRoute: SignInScreen.routeName,
        routes: routes,
      ),
    );
  }
}
