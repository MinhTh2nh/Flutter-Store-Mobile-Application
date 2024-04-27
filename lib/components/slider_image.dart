import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SliderButtons extends StatefulWidget {
  const SliderButtons({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SliderButtonsState createState() => _SliderButtonsState();
}

class _SliderButtonsState extends State<SliderButtons> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  final List<String> items = List<String>.generate(10, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: items.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 22.0),
                    ),
                  ),
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 400.0,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          carouselController: _controller,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.map((item) {
            int index = items.indexOf(item);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? const Color.fromRGBO(0, 0, 0, 0.9)
                    : const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
