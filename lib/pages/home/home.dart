import 'package:flutter/material.dart';
import '../../components/custome_app_bar/custom_app_bar.dart';
import '../../components/product_tile.dart';
import '../../model/cart_model.dart';
import 'package:provider/provider.dart';
import '../../pages/product_detail_page.dart';
import 'small_components/categories.dart';
import 'small_components/discount_banner.dart';
import 'small_components/special_offers.dart';
import 'package:food_mobile_app/components/slider_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String routeName = "/home";

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  int selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        Provider.of<CartModel>(context, listen: false).fetchProducts();
      }
    });
    // Fetch initial products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartModel>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SliderImages(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DiscountBanner(),
                Categories(
                  selectedCategory: selectedCategory,
                  onSelectCategory: (index) {
                    setState(() {
                      selectedCategory = index;
                    });
                  },
                ),
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
                final filteredProducts = cartModel.shopItems.where((product) {
                  final category = product['category'] as String?;
                  return selectedCategory == 0 ||
                      (category != null &&
                          category ==
                              Categories.categories[selectedCategory - 1]
                                  ["text"]);
                }).toList();

                if (cartModel.isLoading && cartModel.shopItems.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (filteredProducts.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.1,
                  ),
                  itemBuilder: (context, index) {
                    var product = filteredProducts[index];
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
                          average_rating:
                              (product['average_rating'] as num?)?.toDouble() ??
                                  0.0,
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
    );
  }
}
