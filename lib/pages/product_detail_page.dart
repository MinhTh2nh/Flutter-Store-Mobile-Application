import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../components/star_rating.dart';
import '../model/cart_model.dart';
import 'package:provider/provider.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final int index;

  const ProductDetailPage({Key? key, required this.index}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  String selectedSize = '';
  int selectedItemID = -1;

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final product = cartModel.shopItems[widget.index];
    final productItems = cartModel.productItems
        .where((item) => item['product_id'] == product['product_id'])
        .toList();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<CartModel>( // Use Consumer to listen to changes in CartModel
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CartPage.routeName);
                    },
                    icon: const Icon(Icons.shopping_basket),
                  ),
                  if (cart.cartItems.isNotEmpty) // Conditionally show the notification badge
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          cart.itemsCount.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5), // Add padding
                    child: SizedBox(
                      height: 0.5 * (MediaQuery.of(context).size.width), // Set height to 30% of the width of the screen
                      child: Image.network(
                        product['imagePath'],
                        width: double.infinity, // Take whole width
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    product['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product['itemPrice']}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 16),
                  Builder(builder: (context) {
                    return Row(
                      children: <Widget>[
                        const Expanded(
                          child: IconTheme(
                            data: IconThemeData(
                              color: Colors.amberAccent,
                              size: 18,
                            ),
                            child: StarDisplay(value: 4),
                          ),
                        ),
                        Container(
                          height: 45.0,
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xFFD0D0D0),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 35.0,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  right: 5.0,
                                  left: 5.0,
                                ),
                                child: Text(
                                  quantity.toString(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(
                                width: 2.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                width: 35.0,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    if (quantity <
                                        (selectedItemID != -1
                                            ? productItems.firstWhere(
                                                (item) =>
                                            item['item_id'] ==
                                                selectedItemID)['stock']
                                            : 1)) {
                                      setState(() {
                                        quantity++;
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: const Text(
                      "Available Options",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Display selection options based on product_items
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: productItems.map<Widget>((item) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSize = item['size'];
                              selectedItemID = item['item_id'];
                              // Reset quantity to 1 when size is changed
                              quantity = 1;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedSize == item['size']
                                    ? Colors.teal // Highlight selected size
                                    : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                              color: selectedSize == item['size']
                                  ? Colors.teal.shade200 // Background color for selected size
                                  : null, // No background color for unselected size
                            ),
                            child: Text(
                              item['size'],
                              style: TextStyle(
                                fontWeight: selectedSize == item['size']
                                    ? FontWeight.bold // Highlight selected size
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: const Text(
                      "About this product",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      product['description'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    height: 48,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedItemID != -1) {
                          final selectedProductItem = productItems.firstWhere(
                                (item) => item['item_id'] == selectedItemID,
                            orElse: () => null,
                          );
                          if (selectedProductItem != null &&
                              selectedProductItem['stock'] >= quantity) {
                            cartModel.addItemToCartWithQuantity(
                              selectedItemID,
                              quantity,
                              selectedSize,
                              product['product_id'],
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product added to cart'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Not enough stock available'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a size'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.teal.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10), // Adjust padding as needed
                        child: SvgPicture.asset(
                          "lib/images/shopping-cart-icon.svg",
                          color: Colors.white,
                          width: 40, // Adjust width of SVG
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Buy Now button press
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.teal.shade200,
                      ),
                      child: Text(
                        "Buy Now".toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
