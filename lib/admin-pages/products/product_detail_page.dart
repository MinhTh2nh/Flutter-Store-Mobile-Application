import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_mobile_app/admin-pages/products/small_components/create_button.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../components/buttons.dart';
import '../../model/cart_model.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ProductDetailPage extends StatefulWidget {
  final int index;
  final void Function() onUpdate; // Declare the callback function
  const ProductDetailPage(
      {Key? key, required this.index, required this.onUpdate})
      : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productThumbnailController =
  TextEditingController();
  final TextEditingController _productDescriptionController =
  TextEditingController();
  final TextEditingController _totalStockController = TextEditingController();
  final TextEditingController _productCategoryController =
  TextEditingController();
  final TextEditingController _productSubCategoryController =
  TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  List _categories = [];
  List _sub_categories = [];
  Map<String, dynamic>? _selectedCategory;
  Map<String, dynamic>? _selectedSubCategory;
  bool _isDataLoaded = false;
  late String _path;
  var path =
      Uri.parse("https://flutter-store-mobile-application-backend.onrender.com/products/get");
  late CartModel _cartModel;
  String? _selectedSizeId = "";

  // Step 1: Initialize an instance of CartModel

  @override
  void initState() {
    super.initState();
    _path =
    "https://flutter-store-mobile-application-backend.onrender.com/products/get/${widget
        .index}";
    _cartModel = CartModel(); // Initialize CartModel
    _fetchCategories(); // Fetch categories data
    _fetchProductDetails();
  }

  Future<void> _fetchCategories() async {
    await _cartModel
        .fetchCategories(); // Call fetchCategories method of CartModel
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
          _sub_categories = subCategories;
        });
      } else {
        throw Exception(
            'Failed to fetch sub categories: ${response.statusCode}');
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
        throw Exception(
            'Failed to fetch sub categories: ${response.statusCode}');
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
          _productPriceController.text =
              responseData['product_price'].toString();
          _productThumbnailController.text = responseData['product_thumbnail'];
          _productDescriptionController.text =
          responseData['product_description'];
          _totalStockController.text = responseData['total_stock'].toString();

          // Set category and sub-category text controllers
          _productCategoryController.text =
              _selectedCategory?['category_id']?.toString() ?? '';
          _productSubCategoryController.text =
              _selectedSubCategory?['sub_id']?.toString() ?? _productSubCategoryController.text;


          // Set data loaded flag
          _isDataLoaded = true;
        });
      } else {
        throw Exception(
            'Failed to fetch product details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching product details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.4,
                    child: Image.network(
                      _productThumbnailController.text,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context,
                          Object exception, StackTrace? stackTrace) {
                        // You can return an error image or a placeholder here
                        return Image.asset(
                          'lib/images/blank.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _productPriceController,
                  decoration: const InputDecoration(
                      labelText: 'Product Price',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _productThumbnailController,
                  decoration: const InputDecoration(
                      labelText: 'Product Thumbnail URL',
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product thumbnail URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _productDescriptionController,
                  decoration: const InputDecoration(
                      labelText: 'Product Description',
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      flex: 7, // 70% width
                      child: TextFormField(
                        controller: _totalStockController,
                        decoration: const InputDecoration(
                          labelText: 'Product Total Stock',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter product total stock';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Add spacing between the text field and the button
                    Expanded(
                      flex: 3, // 30% width
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        // Add padding to center the text vertically
                        child: buttonAdmin(
                          onTap: () {
                            showModalItemSheet(context);
                          },
                          title: "View Item",
                          color: Colors.teal.shade200,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Display current category name
                const SizedBox(height: 15),
                // Dropdown buttons for selecting category and subcategory
                DropdownButtonFormField<String>(
                  value: _selectedCategory != null
                      ? _selectedCategory!['category_id'].toString()
                      : null,
                  items: _categories
                      .map<DropdownMenuItem<String>>((category) {
                    return DropdownMenuItem<String>(
                      value: category['category_id'].toString(),
                      child: Text(category['category_name'] as String),
                    );
                  }).toList(),
                  onChanged: (newValue) async {
                    if (newValue != null && newValue.isNotEmpty) {
                      final selectedCategory = _categories.firstWhere(
                            (category) => category['category_id'].toString() == newValue,
                        orElse: () => null,
                      );

                      if (selectedCategory != null) { // Ensure sub-categories are fetched before updating the state
                        setState(() {
                          _selectedCategory = selectedCategory;
                          _productCategoryController.text = _selectedCategory!['category_name'];
                          fetchSubCategories(int.parse(newValue));
                          _selectedSubCategory = null; // Reset sub-category selection when main category changes
                        });
                      }
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Product Main Category',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select or enter a product category';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: _selectedSubCategory != null
                      ? _selectedSubCategory!['sub_id']?.toString()
                      : null,
                  items: _sub_categories
                      .map<DropdownMenuItem<String>>((sub_category) {
                    return DropdownMenuItem<String>(
                      value: sub_category['sub_id']?.toString(),
                      child: Text(sub_category['sub_name'] as String),
                    );
                  }).toList()
                    ..add(
                      const DropdownMenuItem<String>(
                        value: '', // Add an empty value for "New Sub Category"
                        child: Text('New Sub Category'),
                      ),
                    ),
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue == '') {
                        _showNewSubCategoryDialog(context, _selectedCategory!['category_id']);
                      } else if (newValue != null && newValue.isNotEmpty) {
                        _selectedSubCategory = _sub_categories.firstWhere(
                              (subCategory) => subCategory['sub_id']?.toString() == newValue,
                          orElse: () => null,
                        );
                        _productSubCategoryController.text = _selectedSubCategory?['sub_id']?.toString() ?? '';
                      } else {
                        _selectedSubCategory = null;
                        _productSubCategoryController.text = ''; // Clear the controller if no sub-category is selected
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Product Sub Category',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select or enter a product sub category';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildUpdateButton(),
                    _buildDeleteButton(),
                  ],
                ),
                const SizedBox(height: 10),
                _activateButton(),
              ],
            ),
          ),
        )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Expanded(
      child: DecoratedBox(
        decoration: const BoxDecoration(
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
              "category_id": _selectedCategory?['category_id'],
              "sub_id": _selectedSubCategory?['sub_id'],
              "total_stock": _totalStockController.text,
              "status": "Available",
            };

            print(formData);

            final response = await http.put(
              Uri.parse(
                  "https://flutter-store-mobile-application-backend.onrender.com/products/update/${widget
                      .index}"),
              body: jsonEncode(formData),
              headers: {
                'Content-Type': 'application/json',
              },
            );

            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
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
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.zero,
        ),
        child: buttons(
          title: "Delete",
          color: Colors.red,
          textColor: Colors.white,
          onPress: () async {
            final response = await http.put(Uri.parse(
                "https://flutter-store-mobile-application-backend.onrender.com/products/delete/${widget
                    .index}"));
            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
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
      color: Colors.grey,
      child: DecoratedBox(
        decoration: const BoxDecoration(
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
              Uri.parse(
                  "https://flutter-store-mobile-application-backend.onrender.com/products/update/${widget
                      .index}"),
              body: jsonEncode(formData),
              headers: {
                'Content-Type': 'application/json',
              },
            );

            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
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

  void showModalItemSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: fetchProductItems(widget.index),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                ),
              );
            } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
              return Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        flex: 2, // Takes 20% of the available space
                        child: Padding(
                          padding: EdgeInsets.only(top: 100.0),
                          child: Text(
                            'No items available for this product',
                            style: TextStyle(
                              fontSize: 24, // Increased font size
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showModalNewItemForm(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Create New Item',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              List items = snapshot.data as List;
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10), // Add some spacing
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4, // Set a specific height for the ListView
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                'Item ID: ${items[index]['item_id']}',
                                style: const TextStyle(
                                  fontSize: 18, // Adjust fontsize as needed
                                ),
                              ),
                              subtitle: Text(
                                'Size: ${items[index]['size_name']}, Stock: ${items[index]['stock']}',
                                style: const TextStyle(
                                  fontSize: 18, // Adjust fontsize as needed
                                  fontWeight: FontWeight.bold, // Use FontWeight.bold for bold text
                                ),
                              ),
                              onTap: () {
                                showModalEditItemForm(context, items[index]);
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10), // Add some spacing
                      ElevatedButton(
                        onPressed: () {
                          showModalNewItemForm(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              0,
                            ), // Set borderRadius to 0 for no rounding
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(
                            15.0,
                          ),
                          child: Text(
                            'Create New Item',
                            style: TextStyle(
                              fontSize: 18, // Adjust fontsize as needed
                              color: Colors.white, // Set text color to white
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Add some spacing
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<List<dynamic>> fetchProductItems(int product_id) async {
    final response =
    await http.get(Uri.parse("${path}/itemList/${product_id}"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['data'] as List;
      return jsonData;
    } else {
      throw Exception('Failed to fetch product items: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchProductSize() async {
    final response = await http.get(Uri.parse("${path}/size/get"));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['data'] as List;
      return jsonData;
    } else {
      throw Exception('Failed to fetch size items: ${response.statusCode}');
    }
  }

  void showModalNewItemForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
            left: 20.0,
            right: 20.0,
            top: 20.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock';
                    }
                    return null;
                  },
                ),
                FutureBuilder<List<dynamic>>(
                  future: fetchProductSize(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<dynamic> sizes = snapshot.data!;
                      _selectedSizeId = sizes.isNotEmpty
                          ? sizes.first['size_id'].toString()
                          : null;
                      return DropdownButtonFormField<String>(
                        value: _selectedSizeId,
                        items: [
                          const DropdownMenuItem(
                            value: '0',
                            child: Text('Create New Option'),
                          ),
                          ...sizes.map<DropdownMenuItem<String>>((size) {
                            return DropdownMenuItem<String>(
                              value: size['size_id'].toString(),
                              child: Text(
                                  "${size['size_id']}    ${size['size_name']}"),
                            );
                          }).toList(),
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSizeId = newValue;
                          });
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 15),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedSizeId == '0') {
                      showNewSizeDialog(context);
                    } else {
                      submitFormData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Create',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showNewSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String newSizeName = '';
        return AlertDialog(
          title: const Text('Enter Option Name'),
          content: TextField(
            onChanged: (value) {
              newSizeName = value;
            },
            decoration: const InputDecoration(
              hintText: 'New Option Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Make a POST request to create a new size with newSizeName
                createNewSize(newSizeName);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
  void _showNewSubCategoryDialog(BuildContext context , int category_id) {
    showDialog(
      context: context,
      builder: (context) {
        String newSizeName = '';
        return AlertDialog(
          title: const Text('Enter Sub Category Name'),
          content: TextField(
            onChanged: (value) {
              newSizeName = value;
            },
            decoration: const InputDecoration(
              hintText: 'New Subcategory Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Make a POST request to create a new size with newSizeName
                createNewSubName(newSizeName , category_id);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
  Future<void> createNewSubName(String newSizeName , int category_id) async {
    if (newSizeName != null && newSizeName.isNotEmpty) {
      final formData = {
        "sub_name": newSizeName,
        "category_id" : category_id,
      };
      // Send HTTP POST request
      final response = await http.post(
        Uri.parse(
            "https://flutter-store-mobile-application-backend.onrender.com/products/category/sub_category/create/"),
        body: jsonEncode(formData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
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
                      message: "Options created successfully!",
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
          fetchSubCategories(category_id).then((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ProductDetailPage(index: widget.index, onUpdate: () {  },),
              ),
            );
          });
        });
      } else {
        // Handle error response
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
                      title: "Oh no!!!",
                      message: "Options created unsuccessfully!",
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
    }
  }
  Future<void> createNewSize(String newSizeName) async {
    if (newSizeName != null && newSizeName.isNotEmpty) {
      final formData = {
        "size_name": newSizeName,
      };
      // Send HTTP POST request
      final response = await http.post(
        Uri.parse(
            "https://flutter-store-mobile-application-backend.onrender.com/products/get/size/create"),
        body: jsonEncode(formData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
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
                      message: "Options created successfully!",
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
        // Handle error response
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
                      title: "Oh no!!!",
                      message: "Options created unsuccessfully!",
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
    }
  }
  Future<void> submitFormData() async {
    // Prepare form data
    final formData = {
      "product_id": widget.index,
      "size_id": _selectedSizeId,
      "stock": _stockController.text,
    };
    // Send HTTP POST request
    final response = await http.post(
      Uri.parse("https://flutter-store-mobile-application-backend.onrender.com/products/item/create"),
      body: jsonEncode(formData),
      headers: {'Content-Type': 'application/json'},
    );

    // Check response status
    if (response.statusCode == 200) {
      // Handle successful response
      Navigator.of(context).pop(); // Close the modal bottom sheet
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
                    message: "Item created successfully!",
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
      Navigator.of(context).pop(); // Close the modal bottom sheet
    } else {
      // Handle error response
      Navigator.of(context).pop(); // Close the modal bottom sheet
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
                    title: "Oh no!!!",
                    message: "Item created unsuccessfully!",
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
  }

  Future<void> showModalEditItemForm(BuildContext context, dynamic item) async {
    final TextEditingController _editItemController = TextEditingController(text: item['stock'].toString());
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensure the modal sheet occupies the full height
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20.0,
              right: 20.0,
              top: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                TextFormField(
                  controller: _editItemController,
                  decoration: const InputDecoration(
                    labelText: 'Item Stock',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    final formData = {
                      "stock": _editItemController.text,
                      "product_id": item['product_id'],
                      "size_id": item['size_id']
                    };
                    final response = await http.put(
                      Uri.parse("https://flutter-store-mobile-application-backend.onrender.com/products/update/product/item/${item['item_id']}"),
                      body: jsonEncode(formData),
                      headers: {'Content-Type': 'application/json'},
                    );

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Item updated successfully!'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.of(context).pop();
                      fetchProductItems(widget.index); // Refresh the sub-categories list
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update Item stock: ${response.statusCode}'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
