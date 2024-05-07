import 'package:flutter/material.dart';
import '../components/custome_app_bar/custom_app_bar.dart';
import '../components/product_tile.dart';
import '../model/cart_model.dart';
import 'package:provider/provider.dart';
import '../pages/product_detail_page.dart';
import '../components/slider_buttons.dart';

class Products extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Products({Key? key});
  static String routeName = "/products";

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController(); // Add this line

    scrollController.addListener(() {
      // Add this block
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Provider.of<CartModel>(context, listen: false).fetchProducts();
      }
    });
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SliderButtons(),
              const SizedBox(height: 12),
              Consumer<CartModel>(
                builder: (context, cartModel, child) {
                  if (cartModel.shopItems.isEmpty) {
                    // Display loading indicator until products are fetched
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartModel.shopItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.1,
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ProductTile(
                              product_name: product['product_name'],
                              product_price: product["product_price"].toString(),
                              product_thumbnail: product["product_thumbnail"],
                              total_stock: product['total_stock'],
                              // Inside the GridView.builder itemBuilder
                              onPressed: () => {},
                            ),
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
    );
  }
}
