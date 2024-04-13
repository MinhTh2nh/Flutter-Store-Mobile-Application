import 'package:flutter/material.dart';
import '../components/product_tile.dart';
import '../model/cart_model.dart';
import 'package:provider/provider.dart';
import '../pages/product_detail_page.dart';
import '../components/slider_buttons.dart';

class Products extends StatelessWidget {
  const Products({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Optional: SliderButtons(), if used elsewhere.
              const SizedBox(height: 16),
              Consumer<CartModel>(
                builder: (context, cartModel, child) {
                  if (cartModel.shopItems.isEmpty) {
                    // Display loading indicator until products are fetched
                    return Center(child: CircularProgressIndicator());
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartModel.shopItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.2,
                    ),
                    itemBuilder: (context, index) {
                      var product = cartModel.shopItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(index: index),
                            ),
                          );
                        },
                        child: ProductTile(
                          itemName: product['name'],
                          itemPrice: product['itemPrice'],
                          imagePath: product['imagePath'],
                          onPressed: () => Provider.of<CartModel>(context, listen: false)
                              .addItemToCart(index),
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
