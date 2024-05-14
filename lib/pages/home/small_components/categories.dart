import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories(
      {super.key,
      required this.selectedCategory,
      required this.onSelectCategory});

  final int selectedCategory;
  final Function(int) onSelectCategory;

  static const List<Map<String, dynamic>> categories = [
    {"icon": Icons.shopping_bag, "text": "All"},
    {"icon": Icons.boy, "text": "Clothing"},
    {"icon": Icons.brush, "text": "Cosmetic"},
    {"icon": Icons.healing, "text": "Health"},
    {"icon": Icons.electrical_services, "text": "Electric Devices"},
    {"icon": Icons.toys, "text": "Toys"},
    {"icon": Icons.chair, "text": "Furniture"},
    {"icon": Icons.watch, "text": "Watch"},
  ];

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            Categories.categories.length,
            (index) => CategoryCard(
              icon: Categories.categories[index]["icon"],
              text: Categories.categories[index]["text"],
              press: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              isSelected: selectedIndex == index,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.icon,
    required this.text,
    required this.press,
    required this.isSelected,
  });

  final IconData icon;
  final String text;
  final GestureTapCallback press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 70, // Set a fixed width for each card
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : const Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Icon(icon, color: isSelected ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // Add this
            )
          ],
        ),
      ),
    );
  }
}
