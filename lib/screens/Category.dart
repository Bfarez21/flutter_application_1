import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/vertical-card-Pager.dart'; // Importa el widget personalizado
/*
class VerticalCardScreen extends StatelessWidget {
  const VerticalCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "RED",
      "YELLOW",
      "CYAN",
      "BLUE",
      "GREY",
    ];

    final List<Widget> images = [
      Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: VerticalCardScreen(
          //titles: titles,   // Proporciona los títulos de las tarjetas
         // images: images,   // Proporciona las imágenes
          
        ),
      ),
    );
  }
}
*/


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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Categorias'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center( // Centra el carrusel verticalmente
                child: FractionallySizedBox(
                  widthFactor: 0.9, // Ajusta el ancho del carrusel
                  heightFactor: 0.7, // Ajusta la altura del carrusel
                  child: ProductCarousel(imgArray: SignLanguageData.exampleImages),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
