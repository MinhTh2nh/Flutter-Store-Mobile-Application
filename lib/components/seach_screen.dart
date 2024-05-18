// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:food_mobile_app/model/cart_model.dart';
import 'package:provider/provider.dart';
import '../../pages/products.dart';
import '../pages/product_detail_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  late CartModel _cartModel; // Declare _cartModel variable

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cartModel =
        Provider.of<CartModel>(context); // Capture reference to CartModel
  }

  @override
  void dispose() {
    _cartModel
        .clearSearchResults(); // Clear search results when disposing of the screen
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(4),
            hintText: "Search...",
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.teal.shade200,
            ),
            // prefixIcon: const Icon(Icons.search),
            suffixIcon: InkWell(
              onTap: () {
                final searchQuery = _searchController.text;
                if (searchQuery.isNotEmpty) {
                  // Navigate to the product page with the search query
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Products(),
                    ),
                  );
                }
              },
              child: const Icon(Icons.search),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.teal.shade100, // Set border color here
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            cartModel.search(value);
          },
        ),
      ),
      body: cartModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cartModel.searchResults.length,
              itemBuilder: (context, index) {
                var product = cartModel.searchResults[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: Text(product['product_name']),
                      onTap: () {
                        // Navigate to the product detail page with the selected product index
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(
                                  index: product['product_id'],
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
