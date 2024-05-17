import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final double value;

  const StarDisplay({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    int fullStars = value.floor();
    bool hasHalfStar = value - fullStars >= 0.5;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(
            Icons.star,
            color: Colors.yellow,
            size: 18,
          );
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(
            Icons.star_half,
            color: Colors.yellow,
            size: 18,
          );
        } else {
          return const Icon(
            Icons.star_border,
            color: Colors.yellow,
            size: 18,
          );
        }
      }),
    );
  }
}
