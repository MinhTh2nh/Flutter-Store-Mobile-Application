import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../components/custome_app_bar/custom_app_bar_detail_page.dart';
import '../components/star_rating.dart';
import '../model/cart_model.dart';
import 'package:provider/provider.dart';
import '../components/review_field.dart';

class ProductDetailPage extends StatefulWidget {
  final int index;

  const ProductDetailPage({super.key, required this.index});

  @override
  // ignore: library_private_types_in_public_api
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
    // Fetch product items when building the widget
    Future<void> _fetchProductItems(int productId) async {
      await cartModel.fetchProductItems(productId);
    }
    // Call _fetchProductItems when the widget initializes
    _fetchProductItems(cartModel.shopItems[widget.index]['product_id']);

    final productItems = cartModel.productItems
        .where((item) =>
    item['product_id'] ==
        cartModel.shopItems[widget.index]['product_id'])
        .toList();


    // final productItems = cartModel.productItems
    //     .where((item) => item['product_id'] == product['product_id'])
    //     .toList();

    //sample review data
    final reviews = [
      {
        'username': 'John Doe',
        'reviewText': 'This product is really awesome!',
        'rating': 4,
      },
      {
        'username': 'Jane Doe',
        'reviewText': 'I love this product!',
        'rating': 5,
      },
      {
        'username': 'Bob Smith',
        'reviewText': 'This product is okay.',
        'rating': 3,
      },
      {
        'username': 'Alice Johnson',
        'reviewText': 'Not what I expected.',
        'rating': 2,
      },
    ];

    return Scaffold(
      appBar: const CustomAppBarForDetailPage(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      // Remove the Padding widget
                      child: Image.asset(
                        product['product_thumbnail'],
                        width: double.infinity, // Take whole width
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12), // Adjust padding as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          product['product_name'],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Price: \$${product['product_price'].toString()}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        Builder(builder: (context) {
                          return Row(
                            children: <Widget>[
                              const Expanded(
                                child: IconTheme(
                                  data: IconThemeData(),
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
                                                  ? productItems.firstWhere((item) =>
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: productItems.map<Widget>((item) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = item['size_name'];
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
                                    color: selectedSize == item['size_name']
                                        ? Colors.teal // Highlight selected size
                                        : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: selectedSize == item['size_name']
                                      ? Colors.teal
                                      .shade200 // Background color for selected size
                                      : null, // No background color for unselected size
                                ),
                                child: Text(
                                  item['size_name'],
                                  style: TextStyle(
                                    color: selectedSize == item['size_name']
                                        ? Colors.white // Highlight selected size
                                        : Colors.black,
                                    fontWeight: selectedSize == item['size_name']
                                        ? FontWeight.bold // Highlight selected size
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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
                            product['product_description'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reviews',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ProductReview(reviews: reviews),
                          ],
                        ),
                      ],
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
                        padding: const EdgeInsets.all(
                            10), // Adjust padding as needed
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
