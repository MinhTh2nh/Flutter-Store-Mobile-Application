import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SliderButtons extends StatefulWidget {
  const SliderButtons({super.key});

  @override
  State<SliderButtons> createState() => _SliderButtonsState();
}

class _SliderButtonsState extends State<SliderButtons> {
  final List<String> items = [
    'All',
    'Tee',
    'Hoodie',
    'Sweater',
    'Cardigan',
    'Pant'
  ];
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vertical Carousel Slider with Buttons'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              height: 200.0,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 16 / 9,
              scrollDirection: Axis.vertical,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < items.length; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _controller.animateToPage(i);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: i == _currentIndex ? Colors.blue : null,
                    ),
                    child: Text('Item ${i + 1}'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SliderButtons(),
  ));
}
