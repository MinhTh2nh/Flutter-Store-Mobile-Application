import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../components/buttons.dart';

class CategoryCreationForm extends StatefulWidget {
  final void Function() onUpdate; // Declare and initialize the callback function

  CategoryCreationForm({required this.onUpdate});

  @override
  _CategoryCreationFormState createState() => _CategoryCreationFormState();
}
class _CategoryCreationFormState extends State<CategoryCreationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryDescriptionController = TextEditingController();
  final TextEditingController _categoryThumbnailController = TextEditingController();


  var path = "https://flutter-store-mobile-application-backend.onrender.com/products/category/create";

  @override
  void initState() {
    super.initState();
  }

  void _handleUpdate() {
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Creation Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text("Preview Category Thumbail"),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: _categoryThumbnailController.text.isNotEmpty
                        ? SvgPicture.network(
                      _categoryThumbnailController.text,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'lib/images/blank.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _categoryNameController,
                  decoration: InputDecoration(labelText: 'Category Name', border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Category name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _categoryDescriptionController,
                  decoration: InputDecoration(labelText: 'Category description', border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _categoryThumbnailController,
                  decoration: InputDecoration(labelText: 'Category Thumbail', border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                SizedBox(height: 20),
                buttons(
                  title: "Create",
                  color: Colors.red,
                  textColor: Colors.white,
                  onPress: () {
                    // Validate form
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, proceed with form submission
                      submitFormData();
                    }
                  },
                ).box.width(context.screenWidth - 50).make(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitFormData() async {
    // Prepare form data
    final formData = {
      "category_name": _categoryNameController.text,
      "category_description": _categoryDescriptionController.text,
      "category_thumbnail": _categoryThumbnailController.text,

    };
    // Send HTTP POST request
    final response = await http.post(
      Uri.parse(path),
      body: jsonEncode(formData),
      headers: {'Content-Type': 'application/json'},
    );

    // Check response status
    if (response.statusCode == 200) {
      // Handle successful response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Category created successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pushNamed("/admin/categories");
      widget.onUpdate(); // Trigger the update of the category list
      _handleUpdate();
    } else {
      // Handle error response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create Category!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
