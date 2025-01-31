import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/signLenguageData.dart';
import 'package:flutter_application_1/widgets/Slider-product-vertical.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _SignLanguageScreenState createState() => _SignLanguageScreenState();
}

class _SignLanguageScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text(
          "CategoriasAA",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center( // Centra el carrusel verticalmente
                child: FractionallySizedBox(
                  widthFactor: 0.9, // Ajusta el ancho del carrusel
                  heightFactor: 0.7, // Ajusta la altura del carrusel
                  child: ProductCarousel(imgArray: SignLanguageData.categoryImages),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
