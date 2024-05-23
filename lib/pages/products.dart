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
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Provider.of<CartModel>(context, listen: false).fetchProducts();
      }
    });

    final hasSearchResults =
        Provider.of<CartModel>(context).searchResults.isNotEmpty;

    return Scaffold(
      appBar: hasSearchResults ? _buildAppBar(context) : const CustomAppBar(),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SliderButtons(),
              const SizedBox(height: 12),
              Consumer<CartModel>(
                builder: (context, cartModel, child) {
                  final items = hasSearchResults
                      ? cartModel.searchResults
                      : cartModel.shopItems;

                  if (items.isEmpty) {
                    // Display loading indicator until products are fetched
                    return const Center(child: CircularProgressIndicator());
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.1,
                    ),
                    itemBuilder: (context, index) {
                      var product = items[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                productId: product['product_id'],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: ProductTile(
                            product_name: product['product_name'],
                            product_price: product["product_price"].toString(),
                            product_thumbnail: product["product_thumbnail"],
                            total_stock: product['total_stock'],
                            average_rating: (product['average_rating'] as num?)
                                    ?.toDouble() ??
                                0.0,
                            onPressed: () => {},
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // final cartModel = Provider.of<CartModel>(context, listen: false);
          // cartModel.clearSearchResults();
          Navigator.pop(context);
        },
      ),
      title: const Text('Products'),
    );
  }
}
