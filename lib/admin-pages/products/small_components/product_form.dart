import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../components/buttons.dart';

class ProductCreationForm extends StatefulWidget {
  @override
  _ProductCreationFormState createState() => _ProductCreationFormState();
}

class _ProductCreationFormState extends State<ProductCreationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productThumbnailController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _totalStockController = TextEditingController();
  final TextEditingController _productCategoryController = TextEditingController();
  final TextEditingController _productSubCategoryController = TextEditingController();

  var path = "https://flutter-store-mobile-application-backend.onrender.com/products/get";
  late List _categories = [];
  late List _sub_categories = [];
  Map<String, dynamic>? _selectedCategory;
  Map<String, dynamic>? _selectedSubCategory;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse('${path}/category/categoryList');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> categories = json.decode(response.body)['data'];
        setState(() {
          _categories = categories;
        });
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Creation Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                  items: _categories.map<DropdownMenuItem<String>>((category) {
                    return DropdownMenuItem<String>(
                      value: category['category_id'].toString(),
                      child: Text(category['category_name'] as String),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = _categories.firstWhere((category) => category['category_id'].toString() == newValue, orElse: () => null);
                      if (_selectedCategory != null) {
                        _productCategoryController.text = _selectedCategory!['category_name'];
                        fetchSubCategories(int.parse(newValue!));
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
                  items: _sub_categories.map<DropdownMenuItem<String>>((sub_category) {
                    return DropdownMenuItem<String>(
                      value: sub_category['sub_id'].toString(),
                      child: Text(sub_category['sub_name'] as String),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSubCategory = _sub_categories.firstWhere((sub_category) => sub_category['sub_id'].toString() == newValue);
                      if (_selectedSubCategory == null) {
                        // Handle case for creating a new subcategory
                      } else {
                        _productSubCategoryController.text = _selectedSubCategory!['sub_name'];
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
                SizedBox(height: 15),
                TextFormField(
                  controller: _productDescriptionController,
                  decoration: InputDecoration(labelText: 'Product Description', border: OutlineInputBorder()),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _totalStockController,
                  decoration: InputDecoration(labelText: 'Total Stock', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total stock';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                buttons(
                  title: "Create",
                  color: Colors.red,
                  textColor: Colors.white,
                  onPress: () {
                    // Implement create product functionality
                  },
                ).box.width(context.screenWidth - 50).make(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchSubCategories(int category_id) async {
    final url = Uri.parse('$path/category/sub_category/$category_id');
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
