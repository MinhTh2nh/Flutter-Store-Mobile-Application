import 'package:flutter/material.dart';
import 'package:food_mobile_app/admin-pages/home/small_components/side_menu.dart';
import 'package:food_mobile_app/admin-pages/products/small_components/create_button.dart';
import 'package:food_mobile_app/admin-pages/products/small_components/product_form.dart';
import '../../components/custome_app_bar/custom_app_bar_admin.dart';
import '../../components/product_tile.dart';
import '../../model/cart_model.dart';
import 'package:provider/provider.dart';
import '../products/product_detail_page.dart';

class AdminProductPage extends StatefulWidget {
  const AdminProductPage({Key? key}) : super(key: key);

  static String routeName = "/admin/products";

  @override
  _AdminProductPageState createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  // Define the callback function
  void updateProductList() {
    Provider.of<CartModel>(context, listen: false).fetchProducts();
  }

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        Provider.of<CartModel>(context, listen: false).fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: SideMenu(),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    "List Of Products",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  buttonAdmin(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductCreationForm(onUpdate: updateProductList)),
                      );
                    },
                    title: "NEW",
                    color: Colors.teal.shade200,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            Consumer<CartModel>(
              builder: (context, cartModel, child) {
                if (cartModel.shopItems.isEmpty) {
                  return Center(child: CircularProgressIndicator());
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
                    bool isUnavailable = product['STATUS'] == "Unavailable";

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              index: product['product_id'],
                              // Pass the callback function to the ProductDetailPage
                              onUpdate: updateProductList,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            child: Stack(
                              children: [
                                ProductTile(
                                  product_name: product['product_name'],
                                  product_price: product["product_price"].toString(),
                                  product_thumbnail: product["product_thumbnail"],
                                  total_stock: product['total_stock'], // Convert integer to string
                                  onPressed: () {}, // Placeholder onPressed function
                                ),
                                if (isUnavailable)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                              ],
                            ),
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
