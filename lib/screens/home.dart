import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/drawer.dart';
import 'package:flutter_application_1/widgets/screen_home/sign_to_Text.dart';
import 'package:flutter_application_1/widgets/screen_home/text_to_Sign.dart';
import 'package:flutter_application_1/widgets/screen_home/selection-bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  bool isReversed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toggleLayout() {
    setState(() {
      isReversed = !isReversed;
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center, // Centro del degradado
          radius: 1.0, // Radio del degradado ajustado
          colors: [
            Color(0xFF1F2642), // Color inicial
            Color(0xFF060912), // Color final
          ],
          stops: [0.5, 1.5], // Posiciones de los colores
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // El fondo del Scaffold es transparente para mostrar el degradado
        appBar: Navbar(
          title: "Traductor",
          searchBar: false,
        ),
        drawer: MaterialDrawer(currentPage: "Home"),
        body: Column(
          children: [
            SelectionBar(toggleLayout: toggleLayout, isReversed: isReversed),
            SizedBox(height: 1.0),
            Expanded(
              child: isReversed ? TextToSign() : SignToText(),
            ),
          ],
        ),
      ),
    ),
  );
}

}
