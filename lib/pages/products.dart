import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/custome_app_bar/custom_app_bar.dart';
import '../components/product_tile.dart';
import '../model/cart_model.dart';
import 'package:provider/provider.dart';
import '../pages/product_detail_page.dart';
import '../components/slider_buttons.dart';
class Products extends StatelessWidget {
  const Products({Key? key});
  static String routeName = "/products";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10), // Add padding
            child: SliderButtons(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Consumer<CartModel>(
                      builder: (context, cartModel, child) {
                        if (cartModel.shopItems.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartModel.shopItems.length,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1,
                          ),
                          itemBuilder: (context, index) {
                            var product = cartModel.shopItems[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailPage(index: index),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: ProductTile(
                                  itemName: product['name'],
                                  itemPrice: product['itemPrice'],
                                  imagePath: product['imagePath'],
                                  totalStock: product['totalStock'],
                                  onPressed: () {},
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
