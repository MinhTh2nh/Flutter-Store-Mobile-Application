import 'package:flutter/material.dart';
import 'package:food_mobile_app/pages/sign_in/sign_in.dart';
import 'package:food_mobile_app/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:food_mobile_app/model/cart_model.dart';
import 'consts/consts.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51PJfH1EncpehfcF0tTPnvcpp8d4SxwQmYtYa9f1tOohG6wz4JsnYltX1BTDOCHrg9SVei5Ym0ME7H90yxP3pFrkw00IhjvE2mK";
  await Stripe.instance.applySettings();
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
