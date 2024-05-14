import 'package:flutter/material.dart';
import 'total_widget.dart';

class OverallPortfolioCard extends StatelessWidget {
  final double estimatedRevenue;
  final double realRevenue;

  const OverallPortfolioCard({
    required this.estimatedRevenue,
    required this.realRevenue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: const Color(0x802196F3),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Overall Profit',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TotalWidget(
                  label: "Estimated Revenue",
                  value: estimatedRevenue.toStringAsFixed(2), // Format as string with 2 decimal places
                ),
                Spacer(),
                TotalWidget(
                  label: "Real Revenue",
                  value: realRevenue.toStringAsFixed(2), // Format as string with 2 decimal places
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
