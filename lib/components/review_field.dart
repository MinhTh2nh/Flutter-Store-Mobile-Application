import 'package:flutter/material.dart';
import 'star_rating.dart';

class ProductReview extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  // ignore: use_super_parameters
  const ProductReview({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Reviewed by: ${review['username']}',
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              StarDisplay(value: review['rating']),
              const SizedBox(height: 8),
              Text(
                review['reviewText'],
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
