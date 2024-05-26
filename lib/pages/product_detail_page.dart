// ignore_for_file: avoid_print

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:food_mobile_app/pages/order.dart';
import '../components/custome_app_bar/custom_app_bar_detail_page.dart';
import '../components/star_rating.dart';
import '../model/cart_model.dart';
import 'package:provider/provider.dart';
import '../components/review_field.dart';
import '../model/review_model.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  String selectedSize = '';
  int selectedItemID = -1;
  double averageRating = 0.0;
  bool showAllReviews = false;

  List<Map<String, dynamic>> reviews = [];

  @override
  void initState() {
    super.initState();
    fetchReviewsAndCalculateAverageRating(widget.productId);
    fetchProductItems(widget.productId);
  }

  Future<void> fetchReviewsAndCalculateAverageRating(int productId) async {
    try {
      List<Review> reviewsList = await Review.fetchReview(productId);
      double avgRating = Review.calculateAverageRating(reviewsList);

      List<Map<String, dynamic>> reviewMaps = reviewsList.map((review) {
        return {
          'review_id': review.reviewId,
          'item_id': review.itemId,
          'customer_id': review.customerId,
          'review_rating': review.reviewRating,
          'review_comment': review.reviewComment,
          'review_timestamp': review.reviewTimestamp,
          'name': review.name,
        };
      }).toList();

      setState(() {
        reviews = reviewMaps;
        averageRating = avgRating;
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<void> fetchProductItems(int productId) async {
    await Provider.of<CartModel>(context, listen: false)
        .fetchProductItems(productId);
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final product = cartModel.shopItems
        .firstWhere((p) => p['product_id'] == widget.productId);

    final productItems = cartModel.productItems
        .where((item) => item['product_id'] == widget.productId)
        .toList();

    return Scaffold(
      appBar: const CustomAppBarForDetailPage(),
      body: Container(
        color: Colors.grey.shade100,
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: SizedBox(
                        child: Image.network(
                          product['product_thumbnail'],
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.5,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
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
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: IconTheme(
                                data: const IconThemeData(),
                                child: StarDisplay(value: averageRating),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Container(
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
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Available Options",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: productItems.map<Widget>((item) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = item['size_name'];
                                  selectedItemID = item['item_id'];
                                  quantity = 1;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: selectedSize == item['size_name']
                                        ? Colors.teal
                                        : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: selectedSize == item['size_name']
                                      ? Colors.teal.shade200
                                      : null,
                                ),
                                child: Text(
                                  item['size_name'],
                                  style: TextStyle(
                                    color: selectedSize == item['size_name']
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight:
                                        selectedSize == item['size_name']
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "About this product",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product['product_description'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Reviews',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ProductReview(
                                reviews: showAllReviews
                                    ? reviews
                                    : reviews.take(3).toList(),
                              ),
                              if (reviews.length > 3)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showAllReviews = !showAllReviews;
                                    });
                                  },
                                  child: Text(showAllReviews
                                      ? 'Show Less'
                                      : 'Show More'),
                                ),
                            ],
                          ),
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

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AwesomeSnackbarContent(
                                          title: "Congratulations",
                                          message: "Product added to cart",
                                          contentType: ContentType.success,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AwesomeSnackbarContent(
                                          title: "Oh no!",
                                          message: "Not enough stock to add",
                                          contentType: ContentType.warning,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                            });
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AwesomeSnackbarContent(
                                        title: "Oh no!",
                                        message:
                                            "Please select options first!!",
                                        contentType: ContentType.failure,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.teal.shade200,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
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
                        // Check if a size is selected and quantity is greater than 0
                        if (selectedSize.isNotEmpty && quantity > 0) {
                          // Navigate to OrderPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderPage(),
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AwesomeSnackbarContent(
                                        title: "Oh no!",
                                        message:
                                            "Please select options first!!",
                                        contentType: ContentType.failure,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                          });
                        }
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
        ]),
      ),
    );
  }
}
