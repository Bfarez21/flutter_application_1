import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_1/screens/TextToSigns.dart';

class ProductCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> imgArray;

  const ProductCarousel({
    Key? key,
    required this.imgArray,
  }) : super(key: key);

  @override
  _ProductCarouselState createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.7,
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white,
                  Colors.white,
                  Colors.transparent
                ],
                stops: [0.0, 0.15, 0.85, 1.0],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: CarouselSlider.builder(
              carouselController: _controller,
              itemCount: widget.imgArray.length,
              itemBuilder: (context, index, realIndex) {
                bool isCurrentPage = index == _current;

                return TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 350),
                  tween: Tween<double>(begin: 0, end: isCurrentPage ? 1 : 0.8),
                  curve: Curves.easeOutCubic,
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: isCurrentPage ? 1 : 0.5,
                        child: GestureDetector(
                          onTap: () {
                            // Navegar a la ventana de TextToSigns
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TextToSigns()),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: isCurrentPage ? 0 : 20,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                if (isCurrentPage)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 10),
                                  ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Image(
                                        image: widget.imgArray[index]["img"],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    if (widget.imgArray[index]["description"] !=
                                        null)
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              widget.imgArray[index]
                                                  ["description"]!,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[800],
                                                fontWeight: isCurrentPage
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              options: CarouselOptions(
                height: screenHeight * 0.6,
                enlargeCenterPage: true,
                viewportFraction: 0.7,
                aspectRatio: 1,
                scrollDirection: Axis.vertical,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
          // Indicadores de posición
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.imgArray.asMap().entries.map((entry) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == entry.key
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
