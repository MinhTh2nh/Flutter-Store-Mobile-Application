import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import '../../../components/buttons.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:gcloud/storage.dart';
import 'package:file_picker/file_picker.dart';
import '../api.dart';

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
  File? _selectedFile;
  Uint8List? _fileBytes;
  String? _fileName;
  late CloudApi api;
  bool isUploaded = false;
  bool loading = false;
  bool _isUrlInput = true;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/credentials.json').then((json) {
      api = CloudApi(json);
    });
  }

  void _toggleInputMethod() {
    setState(() {
      _isUrlInput = !_isUrlInput;
      _categoryThumbnailController.clear();
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['svg'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = File(result.files.first.path!);
        _fileName = result.files.first.name;
        _isUrlInput = false;
        _categoryThumbnailController.text = _fileName!;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a valid SVG file.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
                    child: _isUrlInput
                        ? SvgPicture.network(
                      _categoryThumbnailController.text,
                      fit: BoxFit.cover,
                      placeholderBuilder: (BuildContext context) => CircularProgressIndicator(),

                    )
                        : _selectedFile != null
                        ? SvgPicture.file(
                      _selectedFile!,
                      fit: BoxFit.cover,
                      placeholderBuilder: (BuildContext context) => CircularProgressIndicator(),

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

                Row(
                  children: [
                    Expanded(
                      child: _isUrlInput
                          ? TextFormField(
                        controller: _categoryThumbnailController,
                        decoration: InputDecoration(
                          labelText: 'Category Thumbnail URL',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Category thumbnail URL';
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
  Future<String> uploadFileToCloudStorage(File file) async {
    final String fileName = file.path.split('/').last;
    final String filePath = 'categories_icon/$fileName'; // Adjust the file path to include the folder
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

  Future<void> submitFormData() async {
    // Prepare form data
    String thumbnailUrl;
    if (_isUrlInput) {
      thumbnailUrl = _categoryThumbnailController.text;
    } else {
      thumbnailUrl = await uploadFileToCloudStorage(_selectedFile!);
    }

    final formData = {
      "category_name": _categoryNameController.text,
      "category_description": _categoryDescriptionController.text,
      "category_thumbnail": thumbnailUrl,

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
