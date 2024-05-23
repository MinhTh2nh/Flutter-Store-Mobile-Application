import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryTile extends StatelessWidget {
  final String category_name;
  final String category_description;
  final String category_thumbnail;
  final void Function()? onPressed;

  const CategoryTile({
    super.key,
    required this.category_name,
    required this.category_description,
    required this.category_thumbnail,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0), // Add margin bottom
      child: Material(
        elevation: 3, // Add elevation for shadow effect
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: FutureBuilder<String>(
                future: _loadSvgAsString(category_thumbnail),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SvgPicture.network(
                      category_thumbnail,
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.cover,
                    );
                  } else if (snapshot.hasError) {
                    return Image.asset(
                      'lib/images/blank.png',
                      fit: BoxFit.contain,
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8), // Add padding
              child:Center(
                child: Text(
                  category_name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _loadSvgAsString(String url) async {
    // Load SVG content as a string
    return "<svg>Your SVG content here</svg>";
  }
}
