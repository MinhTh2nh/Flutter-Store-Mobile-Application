import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../components/buttons.dart';
import '../../model/cart_model.dart';
class ProductDetailPage extends StatefulWidget {
  final int index;
  final void Function() onUpdate; // Declare the callback function
  const ProductDetailPage({Key? key, required this.index, required this.onUpdate}) : super(key: key);

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

  List _categories = [];
  List _sub_categories = [];
  Map<String, dynamic>? _selectedCategory;
  Map<String, dynamic>? _selectedSubCategory;
  bool _isDataLoaded = false;
  late String _path;
  var path = "https://flutter-store-mobile-application-backend.onrender.com/products/get";
  late CartModel _cartModel;
  // Step 1: Initialize an instance of CartModel

  @override
  void initState() {
    super.initState();
    _path = "https://flutter-store-mobile-application-backend.onrender.com/products/get/${widget.index}";
    _cartModel = CartModel(); // Initialize CartModel
    _fetchCategories(); // Fetch categories data
    _fetchProductDetails();
  }
  Future<void> _fetchCategories() async {
    await _cartModel.fetchCategories(); // Call fetchCategories method of CartModel
    setState(() {
      _categories = _cartModel.categories; // Update _categories using CartModel
    });
  }
  Future<void> fetchSubCategories(int category_id) async {
    final url = Uri.parse('$path/category/sub_category/$category_id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> subCategories = json.decode(response.body)['data'];
        setState(() {
          _sub_categories = _cartModel.categories;
        });
      } else {
        throw Exception('Failed to fetch sub categories: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching sub categories: $error');
    }
  }
  void _handleUpdate() {
    widget.onUpdate();
  }

  Future<void> fetchSubCategoriesInitState(int category_id, int sub_id) async {
    final url = Uri.parse('$path/category/sub_category/$category_id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> subCategories = json.decode(response.body)['data'];
        setState(() {
          _sub_categories = subCategories;
          _selectedSubCategory = _sub_categories.firstWhere(
                (subcategory) => subcategory['sub_id'] == sub_id,
            orElse: () => null,
          );
        });
      } else {
        throw Exception('Failed to fetch sub categories: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching sub categories: $error');
    }
  }


  Future<void> _fetchProductDetails() async {
    try {
      final response = await http.get(Uri.parse(_path));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];

        final categoryId = responseData['category_id'];

        final subId = responseData['sub_id'];

        // Fetch sub-categories and set selected sub-category
        await fetchSubCategoriesInitState(categoryId, subId);

        // Set selected category
        setState(() {
          _selectedCategory = _categories.firstWhere(
                (category) => category['category_id'] == categoryId,
            orElse: () => null,
          );

          // Set product details
          _productNameController.text = responseData['product_name'];
          _productPriceController.text = responseData['product_price'].toString();
          _productThumbnailController.text = responseData['product_thumbnail'];
          _productDescriptionController.text = responseData['product_description'];
          _totalStockController.text = responseData['total_stock'].toString();

          // Set category and sub-category text controllers
          _productCategoryController.text = _selectedCategory?['category_id']?.toString() ?? '';
          _productSubCategoryController.text = _selectedSubCategory?['sub_id']?.toString() ?? '';
          print(_selectedSubCategory);
          print("Fetched from server responseData['sub_id'] :" + responseData['sub_id'].toString());

          // Set data loaded flag
          _isDataLoaded = true;
        });
      } else {
        throw Exception('Failed to fetch product details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching product details: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: _isDataLoaded
            ? SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.network(
                      _productThumbnailController.text,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        // You can return an error image or a placeholder here
                        return Image.asset(
                          'lib/images/blank.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                TextFormField(
                  controller: _productDescriptionController,
                  decoration: InputDecoration(labelText: 'Product Description', border: OutlineInputBorder()),
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
                  decoration: InputDecoration(labelText: 'Product Total Stock', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product total stock';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                // Display current category name
                SizedBox(height: 15),
                // Dropdown buttons for selecting category and subcategory
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
                      _selectedSubCategory = _sub_categories.firstWhere((sub_category) => sub_category['sub_id'].toString() == newValue);
                      if (_selectedSubCategory == null) {
                        // Handle case for creating a new category
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
                SizedBox(height: 20),
                Row(
                  children: [
                    _buildUpdateButton(),
                    _buildDeleteButton(),
                  ],
                ),
                SizedBox(height: 10),
                _activateButton(),
              ],
            ),
          ),
        )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
        ),
        child: buttons(
          title: "Update",
          color: Colors.teal.shade200,
          textColor: Colors.white,
          onPress: () async {
            final formData = {
              "product_name": _productNameController.text,
              "product_price": _productPriceController.text,
              "product_thumbnail": _productThumbnailController.text,
              "product_description": _productDescriptionController.text,
              "category_id": _productCategoryController.text,
              "sub_id": _productSubCategoryController.text,
              "total_stock": _totalStockController.text,
              "status": "Available",
            };

            final response = await http.put(
              Uri.parse("https://flutter-store-mobile-application-backend.onrender.com/products/update/${widget.index}"),
              body: jsonEncode(formData),
              headers: {
                'Content-Type': 'application/json',
              },
            );

            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product updated successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.of(context).pushNamed("/admin/products");
              _handleUpdate();
            } else {
              throw Exception('Failed to update product_id: ${widget.index}');
            }
          },
        ).box.width(context.screenWidth - 50).make(),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
        ),
        child: buttons(
          title: "Delete",
          color: Colors.red,
          textColor: Colors.white,
          onPress: () async {
            final response = await http.put(Uri.parse("https://flutter-store-mobile-application-backend.onrender.com/products/delete/${widget.index}"));
            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product deleted successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.of(context).pushNamed("/admin/products");
              _handleUpdate();
            } else {
              throw Exception('Failed to delete product_id: ${widget.index}');
            }
          },
        ).box.width(context.screenWidth - 50).make(),
      ),
    );
  }

  Widget _activateButton() {
    return Container(
      width: double.infinity,
      color: Colors.grey ,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
        ),
        child: buttons(
          title: "Activate",
          color: Colors.teal.shade200,
          textColor: Colors.white,
          onPress: () async {
            final formData = {
              "product_name": _productNameController.text,
              "product_price": _productPriceController.text,
              "product_thumbnail": _productThumbnailController.text,
              "product_description": _productDescriptionController.text,
              "category_id": _productCategoryController.text,
              "sub_id": _productSubCategoryController.text,
              "total_stock": _totalStockController.text,
              "status": "Available",
            };

            final response = await http.put(
              Uri.parse("https://flutter-store-mobile-application-backend.onrender.com/products/update/${widget.index}"),
              body: jsonEncode(formData),
              headers: {
                'Content-Type': 'application/json',
              },
            );

            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product activated successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.of(context).pushNamed("/admin/products");
              _handleUpdate();
            } else {
              throw Exception('Failed to activate product_id: ${widget.index}');
            }
          },
        ),
      ),
    );
  }
}
