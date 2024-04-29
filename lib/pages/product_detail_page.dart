import 'package:flutter/material.dart';
import '../components/star_rating.dart';
import '../model/cart_model.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final int index;

  const ProductDetailPage({super.key, required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final product = cartModel.shopItems[widget.index];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: 200,
                      child: Image.network(
                        product['imagePath'],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
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
                    'Price: \$${product['itemPrice']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  // Additional product details like size and color could be added here if they are included in your Firestore database
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
                          child: Row(children: [
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
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: const Text(
                      "About this product",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold, // Set the fontWeight to bold
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
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                cartModel.addItemToCartWithQuantity(widget.index, quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product added to cart'),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.teal.shade200),
              ),
              child: const Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
