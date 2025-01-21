/*import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/slider-product.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart'; // Importar la librería
import 'package:flutter_application_1/constants/signLenguageData.dart';
import 'dart:async';
class VerticalCardPagerDemo extends StatefulWidget {
  @override
  _VerticalCardPagerDemoState createState() => _VerticalCardPagerDemoState();
}

class _VerticalCardPagerDemoState extends State<VerticalCardPagerDemo> {
   final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  
  final List<String> titles = [
    "RED",
    "YELLOW",
    "CYAN",
    "BLUE",
    "GREY",
  ];
@override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < titles.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> images = [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20), // Margen horizontal
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      Container(
         margin: EdgeInsets.symmetric(horizontal: 20), // Margen horizontal
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20), // Margen horizontal
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20), // Margen horizontal
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 20), // Margen horizontal
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categorias',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height, // O un tamaño específico
          child: VerticalCardPager(
            titles: titles,
            images: images,
            onPageChanged: (page) {
              // Maneja el cambio de página aquí si es necesario
            },
            align: ALIGN.CENTER, // Para alinear los elementos de la tarjeta en el centro
            onSelectedItem: (index) {
              // Maneja la selección de un elemento aquí si es necesario
              print("Selected index: $index");
              Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductCarousel(imgArray: SignLanguageData.exampleImages)),
                            );
            },
            
          ),
        ),
      ),
    );
  }
}
*/
