import 'package:flutter/material.dart';
import '../../components/custome_app_bar/custom_app_bar.dart';
import '../../components/product_tile.dart'; // Add this line
import '../../model/cart_model.dart';
import 'package:provider/provider.dart';
import '../../pages/product_detail_page.dart';
import 'small_components/categories.dart';
import 'small_components/discount_banner.dart';
import 'small_components/special_offers.dart';
import 'package:food_mobile_app/components/slider_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static String routeName = "/home";

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
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SliderImages(),
            const Column(
              // Wrap DiscountBanner and Categories in a Column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DiscountBanner(),
                Categories(),
              ],
            ),
            const SpecialOffers(),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "New Arrivals",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }
}
