import 'package:flutter/material.dart';

class SliderButtons extends StatefulWidget {
  @override
  _SliderButtonsState createState() => _SliderButtonsState();
}

class _SliderButtonsState extends State<SliderButtons> {
  final List<String> categories = [
    'All',
    'Clothes',
    'Watches',
    'Bag',
    'Shoes',
    'T-Shirt',
    'Electric Watch' ,
    'Mechanical Watch'
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .asMap()
              .entries
              .map(
                (entry) => buildCategory(entry.key),
          )
              .toList(),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 7.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedIndex == index
                      ? Colors.teal // Highlight selected size
                      : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(3.0),
                color: selectedIndex == index
                    ? Colors.teal.shade200 // Background color for selected size
                    : null, // No background color for unselected size
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontWeight: selectedIndex == index
                      ? FontWeight.bold // Highlight selected size
                      : FontWeight.normal,
                  color: selectedIndex == index
                      ? Color(0xFF535353)
                      : Color(0xFFACACAC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
