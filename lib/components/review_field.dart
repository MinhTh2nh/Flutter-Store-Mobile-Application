import 'package:flutter/material.dart';
import 'star_rating.dart';
import 'package:intl/intl.dart';

class ProductReview extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  // ignore: use_super_parameters
  const ProductReview({Key? key, required this.reviews}) : super(key: key);

  String refactorReviewTimestamp(String timestamp) {
    // Parse the timestamp string to DateTime object
    DateTime dateTime = DateTime.parse(timestamp);

    // Format the DateTime object to the desired format
    String formattedDateTime =
        DateFormat('HH:mm:ss dd/MM/yyyy').format(dateTime);

    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[200],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10), // Adjust the radius as needed
                child: Container(
                  // color: Colors.grey[200],
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviewed by: ${review['name']}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            refactorReviewTimestamp(
                                review['review_timestamp'] as String),
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      StarDisplay(value: review['review_rating']),
                      const SizedBox(height: 8),
                      Text(
                        review['review_comment'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
