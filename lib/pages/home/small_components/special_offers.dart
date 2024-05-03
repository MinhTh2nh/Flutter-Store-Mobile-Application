import 'package:flutter/material.dart';
import 'package:food_mobile_app/pages/products.dart';

import 'section_title.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5 ),
          child: SectionTitle(
            title: "Special for you",
            press: () {},
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SpecialOfferCard(
                image: "lib/images/Image Banner 2.png",
                category: "GenZ Fashion Trends",
                numOfBrands: 18,
                press: () {
                  Navigator.pushNamed(context, Products.routeName);
                },
              ),
              SpecialOfferCard(
                image: "lib/images/Image Banner 3.jpg",
                category: "Fashion For Worker",
                numOfBrands: 24,
                press: () {
                  Navigator.pushNamed(context, Products.routeName);
                },
              ),
              SpecialOfferCard(
                image: "lib/images/Image Banner 1.png",
                category: "Minimalist Style",
                numOfBrands: 24,
                press: () {
                  Navigator.pushNamed(context, Products.routeName);
                },
              ),
              SpecialOfferCard(
                image: "lib/images/Image Banner 1.png",
                category: "Minimalist Style",
                numOfBrands: 24,
                press: () {
                  Navigator.pushNamed(context, Products.routeName);
                },
              ),
              SpecialOfferCard(
                image: "lib/images/Image Banner 1.png",
                category: "Minimalist Style",
                numOfBrands: 24,
                press: () {
                  Navigator.pushNamed(context, Products.routeName);
                },
              ),
              const SizedBox(width: 24), // Add additional space at the end
            ],
          ),
        ),
      ],
    );
  }
}
class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: 242, // Set the width
          height: 100, // Set the height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black87,
                Colors.black38,
                Colors.black26,
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$numOfBrands Items',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

