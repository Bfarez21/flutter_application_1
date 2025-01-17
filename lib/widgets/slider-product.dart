import 'package:flutter/material.dart';  
import 'package:carousel_slider/carousel_slider.dart';  

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

  @override  
  Widget build(BuildContext context) {  
    final screenWidth = MediaQuery.of(context).size.width;  

    return Container(  
      width: screenWidth * 0.9, // 90% del ancho de la pantalla  
      child: CarouselSlider(  
        items: widget.imgArray  
            .map((item) => Column(  
                  children: [  
                    Container(  
                      margin: const EdgeInsets.all(8.0),  
                      decoration: BoxDecoration(  
                        boxShadow: [  
                          BoxShadow(  
                            color: Colors.black.withOpacity(0.3),  
                            blurRadius: 8,  
                            spreadRadius: 0.3,  
                            offset: const Offset(0, 3),  
                          ),  
                        ],  
                      ),  
                      child: ClipRRect(  
                        borderRadius: BorderRadius.circular(8.0),  
                        child: Image(  
                          image: item["img"], // Garantiza que item["img"] sea siempre AssetImage  
                          fit: BoxFit.cover,  
                          width: double.infinity,  
                          height: screenWidth * 0.5, // Altura dinámica según ancho  
                        ),  
                      ),  
                    ),  
                    if (item["description"] != null)  
                      Padding(  
                        padding: const EdgeInsets.all(8.0),  
                        child: Text(  
                          item["description"]!,  
                          style: const TextStyle(  
                            fontSize: 14,  
                            color: Colors.grey,  
                          ),  
                          textAlign: TextAlign.center,  
                        ),  
                      ),  
                  ],  
                ))  
            .toList(),  
        options: CarouselOptions(  
          autoPlay: true,  
          enlargeCenterPage: true,  
          aspectRatio: 4 / 3,  
          enableInfiniteScroll: true,  
          onPageChanged: (index, reason) {  
            setState(() {  
              _current = index;  
            });  
          },  
        ),  
      ),  
    );  
  }  
}