// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../pages/products.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final FocusNode _searchFocusNode = FocusNode();

    // Set focus on search field when the screen is built
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
    // Retrieve product names from your data source
    List<String> productNames = [
      'Product 1',
      'Product 2',
      'Product 3'
    ]; // Example product names

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(4),
            hintText: "Search...",
            hintStyle: TextStyle(
              fontSize: 18,
              color: Colors.teal.shade200,
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: const Icon(Icons.camera_alt_outlined),
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
            // Handle search query changes
          },
        ),
      ),
      body: ListView.builder(
        itemCount: productNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(productNames[index]),
            onTap: () {
              // Navigate to products page with the selected product nam
            },
          );
        },
      ),
    );
  }
}
