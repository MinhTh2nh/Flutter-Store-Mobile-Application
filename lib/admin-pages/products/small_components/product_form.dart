import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcloud/storage.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'package:file_picker/file_picker.dart';

import '../../../components/buttons.dart';
import '../api.dart';

class ProductCreationForm extends StatefulWidget {
  final void Function() onUpdate;

  ProductCreationForm({required this.onUpdate});

  @override
  _ProductCreationFormState createState() => _ProductCreationFormState();
}

class _ProductCreationFormState extends State<ProductCreationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productThumbnailController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productCategoryController = TextEditingController();
  final TextEditingController _productSubCategoryController = TextEditingController();

  File? _selectedFile;
  Uint8List? _fileBytes;
  String? _fileName;
  late CloudApi api;
  bool isUploaded = false;
  bool loading = false;

  final String _baseUrl = "https://flutter-store-mobile-application-backend.onrender.com";
  late List _categories = [];
  late List _subCategories = [];
  Map<String, dynamic>? _selectedCategory;
  Map<String, dynamic>? _selectedSubCategory;

  bool _isUrlInput = true;


  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/credentials.json').then((json) {
      api = CloudApi(json);
    });
    fetchCategories();
  }

  void _toggleInputMethod() {
    setState(() {
      _isUrlInput = !_isUrlInput;
      _productThumbnailController.clear();
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && (result.files.single.extension == 'jpg' ||
        result.files.single.extension == 'png')) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileBytes = result.files.single.bytes;
        _fileName = result.files.single.name;
        _isUrlInput = false;
        _productThumbnailController.text = _fileName!;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a valid image file (JPG or PNG)'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse('$_baseUrl/products/get/category/categoryList');
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

  Future<void> fetchSubCategories(int categoryId) async {
    final url = Uri.parse(
        '$_baseUrl/products/get/category/sub_category/$categoryId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> subCategories = json.decode(response.body)['data'];
        setState(() {
          _subCategories = subCategories;
        });
      } else {
        throw Exception(
            'Failed to fetch sub categories: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching sub categories: $error');
    }
  }

  Future<void> submitFormData() async {
    if (_formKey.currentState!.validate()) {
      String thumbnailUrl;
      if (_isUrlInput) {
        thumbnailUrl = _productThumbnailController.text;
      } else {
        thumbnailUrl = await uploadFileToCloudStorage(_selectedFile!);
      }

      final formData = {
        "product_name": _productNameController.text,
        "product_price": _productPriceController.text,
        "product_thumbnail": thumbnailUrl,
        "product_description": _productDescriptionController.text,
        "category_id": _selectedCategory!['category_id'],
        "sub_id": _selectedSubCategory!['sub_id'],
        "total_stock": 0,
        "status": "Available",
      };

      final response = await http.post(
        Uri.parse("$_baseUrl/products/create"),
        body: jsonEncode(formData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product created successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        widget.onUpdate();
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create product!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<String> uploadFileToCloudStorage(File file) async {
    final String fileName = file.path.split('/').last;
    final String filePath = 'product_images/$fileName'; // Adjust the file path to include the folder
    final ObjectInfo response = await api.save(filePath, file.readAsBytesSync());
    setState(() {
      loading = false;
      isUploaded = true;
    });
    // Construct the URL manually
    final String bucketName = 'bucket_mobile'; // Replace with your actual bucket name
    final String fileUrl = 'https://storage.googleapis.com/$bucketName/$filePath';
    return fileUrl;
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
                SizedBox(height: 10),
            Text("Preview Product Thumbnail"),
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
                child: _isUrlInput
                    ? Image.network(
                  _productThumbnailController.text,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(
                      'lib/images/blank.png',
                      fit: BoxFit.cover,
                    );
                  },
                )
                    : _selectedFile != null
                    ? Image.file(
                  _selectedFile!,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'lib/images/blank.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(
                  labelText: 'Product Name', border: OutlineInputBorder()),
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
              decoration: InputDecoration(
                  labelText: 'Product Price', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product price';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _isUrlInput
                      ? TextFormField(
                    controller: _productThumbnailController,
                    decoration: InputDecoration(
                      labelText: 'Product Thumbnail URL',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product thumbnail URL';
                      }
                      return null;
                    },
                  )
                      : ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: Icon(Icons.file_upload),
                    label: Text('Choose File'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_isUrlInput ? Icons.upload_file : Icons.link),
                  onPressed: _toggleInputMethod,
                  tooltip: _isUrlInput
                      ? 'Switch to file upload'
                      : 'Switch to URL input',
                ),
              ],
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
                value: _selectedSubCategory != null
                    ? _selectedSubCategory!['sub_id'].toString()
                    : null,
                items: _subCategories.map<DropdownMenuItem<String>>((
                    subCategory) {
                  return DropdownMenuItem<String>(
                    value: subCategory['sub_id'].toString(),
                    child: Text(subCategory['sub_name'] as String),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSubCategory = _subCategories.firstWhere(
                            (subCategory) =>
                        subCategory['sub_id'].toString() == newValue);
                    if (_selectedSubCategory != null) {
                      _productSubCategoryController.text =
                      _selectedSubCategory!['sub_name'];
                    }
                  });
                },
                decoration: InputDecoration(
                    labelText: 'Product Sub Category',
                    border: OutlineInputBorder()),
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
                decoration: InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder()),
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
              SizedBox(height: 20),
              buttons(
                title: "Create",
                color: Colors.red,
                textColor: Colors.white,
                onPress: () {
                  if (_formKey.currentState!.validate()) {
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
}
