// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class Review {
  final int reviewId;
  final int itemId;
  final int customerId;
  final double reviewRating;
  final String reviewComment;
  final String reviewTimestamp;
  final String name;

  Review({
    required this.reviewId,
    required this.itemId,
    required this.customerId,
    required this.reviewRating,
    required this.reviewComment,
    required this.reviewTimestamp,
    required this.name,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'],
      itemId: json['item_id'],
      customerId: json['customer_id'],
      reviewRating: (json['review_rating'] as num)
          .toDouble(), // Ensure it's parsed as double
      reviewComment: json['review_comment'],
      reviewTimestamp: json['review_timestamp'],
      name: json['name'],
    );
  }

  static Future<List<Review>> fetchReview(int productId) async {
    final apiUrl =
        'https://flutter-store-mobile-application-backend.onrender.com/products/$productId/reviews';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        List<dynamic> data = jsonResponse['data'];
        return data.map((review) => Review.fromJson(review)).toList();
      } else {
        throw Exception('Failed to fetch reviews: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to fetch reviews');
    }
  }

  //calculate average rating
  static double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) {
      return 0.0;
    }

    // Filter out the reviews with ratings that are not multiples of 0.5
    List<Review> filteredReviews =
        reviews.where((review) => review.reviewRating % 0.5 == 0).toList();

    if (filteredReviews.isEmpty) {
      return 0.0; // If there are no reviews with valid ratings, return 0 as the average rating
    }

    // Calculate the total rating
    double totalRating = filteredReviews.fold(
        0, (previousValue, review) => previousValue + review.reviewRating);

    // Calculate the average rating
    double averageRating = totalRating / filteredReviews.length;

    return averageRating;
  }

  //create a review
  static Future<void> addReview({
    required double reviewRating,
    required String reviewComment,
    required int itemId,
    required int customerId,
  }) async {
    const apiUrl =
        'https://flutter-store-mobile-application-backend.onrender.com/products/review/create';

    final Map<String, dynamic> requestData = {
      'review_rating': reviewRating,
      'review_comment': reviewComment,
      'item_id': itemId,
      'customer_id': customerId,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(requestData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Review added successfully');
    } else {
      print('Failed to add review: ${response.statusCode}');
      throw Exception('Failed to add review: ${response.statusCode}');
    }
  }
}
