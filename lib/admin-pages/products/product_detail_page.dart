import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

import '../../components/buttons.dart';
import '../../model/cart_model.dart';

class ProductDetailPage extends StatefulWidget {
  final int index;
  const ProductDetailPage({super.key, required this.index});
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productThumbnailController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _totalStockController = TextEditingController();
  final TextEditingController _productCategoryController = TextEditingController();
  final TextEditingController _productSubCategoryController = TextEditingController();

  late List _categories = [];
  late List _sub_categories = [];
  Map<String, dynamic>? _selectedCategory;
  Map<String, dynamic>? _selectedSubCategory;
  bool _isDataLoaded = false;
  var path = "https://flutter-store-mobile-application-backend.onrender.com/products/get";

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final product = cartModel.shopItems[widget.index];

    // Fetch product items when building the widget
    Future<void> _fetchProductItems(int productId) async {
      await cartModel.fetchProductItems(productId);
      setState(() {
        _isDataLoaded = true;
      });
    }

    // Call _fetchProductItems when the widget initializes
    _fetchProductItems(cartModel.shopItems[widget.index]['product_id']);
    final productItems = cartModel.productItems
        .where((item) => item['product_id'] == cartModel.shopItems[widget.index]['product_id'])
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Of Product : ' + cartModel.shopItems[widget.index]['product_id']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: _isDataLoaded
            ? Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _productPriceController,
                decoration: InputDecoration(labelText: 'Product Price', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _productThumbnailController,
                decoration: InputDecoration(labelText: 'Product Thumbnail URL', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product thumbnail URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedCategory != null ? _selectedCategory!['category_id'].toString() : null,
                items: [
                  ..._categories.map<DropdownMenuItem<String>>((category) {
                    return DropdownMenuItem<String>(
                      value: category['category_id'].toString(),
                      child: Text(category['category_name'] as String),
                    );
                  }).toList(),
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('New Category'),
                  ),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = _categories.firstWhere((category) => category['category_id'].toString() == newValue);
                    if (_selectedCategory == null) {
                      // Handle case for creating a new category
                    } else {
                      _productCategoryController.text = _selectedCategory!['category_name'];
                      fetchSubCategories(_selectedCategory!['category_id']);
                    }
                  });
                },
                decoration: InputDecoration(labelText: 'Product Main Category', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select or enter a product category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedSubCategory != null ? _selectedSubCategory!['sub_id'].toString() : null,
                items: [
                  ..._sub_categories.map<DropdownMenuItem<String>>((sub_category) {
                    return DropdownMenuItem<String>(
                      value: sub_category['sub_id'].toString(),
                      child: Text(sub_category['sub_name'] as String),
                    );
                  }).toList(),
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('New Sub Category'),
                  ),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _selectedSubCategory = _categories.firstWhere((sub_category) => sub_category['sub_id'].toString() == newValue);
                    if (_selectedSubCategory == null) {
                      // Handle case for creating a new category
                    } else {
                      _productSubCategoryController.text = _selectedSubCategory!['sub_name'];
                      fetchSubCategories(_selectedCategory!['category_id']);
                    }
                  });
                },
                decoration: InputDecoration(labelText: 'Product Sub Category', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select or enter a product sub category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _productDescriptionController,
                decoration: InputDecoration(labelText: 'Product Description', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product description URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _totalStockController,
                decoration: InputDecoration(labelText: 'Product Total Stock', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter product's stock";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildUpdateButton(),
            ],
          ),
        )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildUpdateButton() {
    if (_isDataLoaded) {
      return buttons(
        title: "Update",
        color: Colors.teal.shade200,
        textColor: Colors.white,
        onPress: () {
          // Implement update product functionality
        },
      ).box.width(context.screenWidth - 50).make();
    } else {
      return Opacity(
        opacity: 0.5,
        child: buttons(
          title: "Update",
          color: Colors.teal.shade200,
          textColor: Colors.white,
          onPress: () {
            // Implement update product functionality
          },
        ).box.width(context.screenWidth - 50).make(),
      );
    }
  }
  Future<void> fetchSubCategories(int category_id) async {
    final url = Uri.parse('${path}/category/sub_category/$category_id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> subCategories = json.decode(response.body)['data'];
        setState(() {
          _sub_categories = subCategories;
        });
      } else {
        throw Exception('Failed to fetch sub categories: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching sub categories: $error');
    }
  }
}
