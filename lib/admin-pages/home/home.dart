import 'package:flutter/material.dart';
import 'package:food_mobile_app/admin-pages/home/small_components/side_menu.dart';
import '../../components/custome_app_bar/custom_app_bar_admin.dart';
import '../../model/cart_model.dart';
import 'package:provider/provider.dart';


class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});
  static String routeName = "/admin";

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Provider.of<CartModel>(context, listen: false).fetchProducts();
      }
    });

    return Scaffold(
      appBar: CustomAppBar(), // No need for const here
      drawer: SideMenu(),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}

