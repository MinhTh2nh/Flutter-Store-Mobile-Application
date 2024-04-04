import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import QuerySnapshot
import '../components/product_tile.dart';
import '../model/cart_model.dart';
import 'package:provider/provider.dart';
import '../pages/product_detail_page.dart';
import '../components/slider_buttons.dart';
import '../backend//services/firestore_services.dart'; // Import your FirestoreServices class


class Products extends StatelessWidget {
  const Products({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Wrap your Column with SingleChildScrollView
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // const SliderButtons(),
              const SizedBox(height: 16),
              Consumer<CartModel>(
                builder: (context, value, child) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                    builder: (context, snapshot) {

                      print(snapshot.data); // Log the snapshot data

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('No data available.'),
                        );
                      }

                      var products = snapshot.data!.docs;
                      print(products); // Log the snapshot data

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.2,
                        ),
                        itemBuilder: (context, index) {
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
                            child: ProductTile(
                              itemName: products[index]['name'],
                              itemPrice: products[index]['price'].toString(),
                              imagePath: products[index]['imageUrl'],
                              onPressed: () {
                                Provider.of<CartModel>(context, listen: false)
                                    .addItemToCart(index);
                              },
                            ),
                          );
                        },
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
