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
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// import 'package:food_mobile_app/payment/vnpay/makePaymentVnpay.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Payment Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const HomePage(),
//         '/payment_status': (context) => const PaymentStatusPage(),
//       },
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final String txnRef = _generateTxnRef();
//             const String vndAmount = '100000';
//             const String url = 'https://vnpay-be-z22c.onrender.com/order/create_payment_url?amount=$vndAmount';
//             final String? result = await Navigator.push<String>(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => WebViewPage(url: url),
//               ),
//             );
//
//             if (result != null) {
//               if (result == '00') {
//                 // Payment was successful
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Payment Successful')),
//                 );
//               } else {
//                 // Payment failed
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Payment Failed')),
//                 );
//               }
//             }
//           },
//           child: const Text('Launch Payment Page'),
//         ),
//       ),
//     );
//   }
// }
//
// class PaymentStatusPage extends StatelessWidget {
//   const PaymentStatusPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final String code = ModalRoute.of(context)!.settings.arguments as String;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment Status'),
//       ),
//       body: Center(
//         child: Text('Payment Status: $code'),
//       ),
//     );
//   }
// }