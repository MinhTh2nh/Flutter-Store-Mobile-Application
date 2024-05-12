import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../components/buttons.dart';
import '../../model/cart_model.dart';

class CategoryDetailPage extends StatefulWidget {
  final int index;
  final void Function() onUpdate; // Declare the callback function
  const CategoryDetailPage({Key? key, required this.index, required this.onUpdate}) : super(key: key);

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryDescriptionController = TextEditingController();
  final TextEditingController _categoryThumbnailController = TextEditingController();
  final TextEditingController _subNameController = TextEditingController();

  List _sub_categories = [];
  bool _isDataLoaded = false;
  late String _path;
  var path = "https://flutter-store-mobile-application-backend.onrender.com/products/get/category";
  var path2 = "https://flutter-store-mobile-application-backend.onrender.com/products/category";
  late CartModel _cartModel;

  @override
  void initState() {
    super.initState();
    _path = "$path/categoryList/${widget.index}";
    _cartModel = CartModel(); // Initialize CartModel
    fetchCategoryDetail(widget.index);
    fetchSubCategories(widget.index);
  }

  Future<void> fetchSubCategories(int category_id) async {
    final url = Uri.parse('$path/sub_category/$category_id');
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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Category Detail')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: _isDataLoaded
              ? Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: SvgPicture.network(
                      _categoryThumbnailController.text,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _categoryDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Category Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    _buildViewSubCategoryButton(),
                    SizedBox(width: 15),
                    _buildUpdateButton(),
                  ],
                ),
                // Display other UI elements...
              ],
            ),
          )
              : Center(child: CircularProgressIndicator()),
        ),
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
              "category_name": _categoryNameController.text,
              "category_description": _categoryDescriptionController.text,
              "category_thumbnail": _categoryThumbnailController.text,
            };

            final response = await http.put(
              Uri.parse(
                  "https://flutter-store-mobile-application-backend.onrender.com/products/update/category/${widget.index}"),
              body: jsonEncode(formData),
              headers: {'Content-Type': 'application/json'},
            );

            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Category updated successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.of(context).pushNamed("/admin/categories");
              _handleUpdate();
            } else {
              throw Exception('Failed to update category_id: ${widget.index}');
            }
          },
        ).box.width(context.screenWidth - 50).make(),
      ),
    );
  }

  Widget _buildViewSubCategoryButton() {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
        ),
        child: buttons(
          title: "View Sub Category",
          color: Colors.teal.shade200,
          textColor: Colors.white,
          onPress: () {
            showModalItemSheet(context);
          },
        ).box.width(context.screenWidth - 50).make(),
      ),
    );
  }

  void showModalItemSheet(BuildContext context) {
    // Call fetchSubCategories to get the latest data before showing the bottom sheet
    fetchSubCategories(widget.index);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _sub_categories.isEmpty
            ? Center(
          child: CircularProgressIndicator(),
        )
            : _buildSubCategoryList();
      },
    );
  }

  Future<void> showModalNewItemForm(BuildContext context) async {
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
                SizedBox(height: 15),
                // TextFormField for inputting stock
                TextFormField(
                  controller: _subNameController,
                  // Assign the _stockController here
                  decoration: InputDecoration(
                    labelText: 'Sub-category Name',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the modal bottom sheet
                    submitFormData().then((value) {
                      // Execute code after form submission is complete
                      // Fetch the latest sub-categories data after the form is closed
                      fetchSubCategories(widget.index);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        0,
                      ), // Set borderRadius to 0 for no rounding
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      15.0,
                    ),
                    // Adjust padding as needed
                    child: Text(
                      'Create',
                      style: TextStyle(
                        fontSize: 18, // Adjust fontsize as needed
                        color: Colors.white, // Set text color to white
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


  Future<void> fetchCategoryDetail(int category_id) async {
    try {
      final response =
      await http.get(Uri.parse("$path/categoryList/$category_id"));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body)['data'];
        setState(() {
          _categoryNameController.text = responseData['category_name'];
          _categoryThumbnailController.text =
              responseData['category_thumbnail'].toString();
          _categoryDescriptionController.text =
          responseData['category_description'];
          _isDataLoaded = true;
        });
      } else {
        throw Exception(
            'Failed to fetch category detail: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching category detail: $error');
    }
  }
  Future<void> submitFormData() async {
    // Check if the sub-category name is empty
    if (_subNameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter sub-category name"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return; // Stop the function execution
    }

    // Prepare form data
    final formData = {
      "category_id": widget.index,
      "sub_name": _subNameController.text,
    };

    // Send HTTP POST request
    final response = await http.post(
      Uri.parse("${path2}/sub_category/create"),
      body: jsonEncode(formData),
      headers: {'Content-Type': 'application/json'},
    );
    // Check response status
    if (response.statusCode == 200) {
      Navigator.of(context).pop(); // Close the modal bottom sheet
      // Handle successful response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item created successfully!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // Set behavior to floating
        ),
      );
    } else if (response.statusCode == 400) {
      Navigator.of(context).pop(); // Close the modal bottom sheet
      // Handle bad request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create sub-category: Bad request'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // Set behavior to floating
        ),
      );
    } else {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create sub-category: ${response.statusCode}'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // Set behavior to floating
        ),
      );
    }
  }
  Widget _buildSubCategoryList() {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10), // Add some spacing
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4, // Set a specific height for the ListView
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _sub_categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Sub ID: ${_sub_categories[index]['sub_id']}',
                      style: TextStyle(
                        fontSize: 18, // Adjust fontsize as needed
                      ),
                    ),
                    subtitle: Text(
                      'Name: ${_sub_categories[index]['sub_name']}',
                      style: TextStyle(
                        fontSize: 18, // Adjust fontsize as needed
                        fontWeight: FontWeight.bold, // Use FontWeight.bold for bold text
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () {
                showModalNewItemForm(context).then((value) {
                  // Fetch the latest sub-categories data after the form is closed
                  fetchSubCategories(widget.index);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    0,
                  ), // Set borderRadius to 0 for no rounding
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
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
            SizedBox(height: 10), // Add some spacing
          ],
        ),
      ),
    );
  }



}
