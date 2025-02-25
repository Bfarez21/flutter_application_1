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
    // Obtener las dimensiones de la pantalla
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF1F2642),
              Color.fromRGBO(0, 0, 0, 1),
            ],
            stops: [0.5, 1.5],
          ),
        ),
        child: SafeArea(
          // Añadido SafeArea para evitar el overflow con las áreas del sistema
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              // PreferredSize para controlar la altura del AppBar
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Navbar(
                title: "Traductor",
                searchBar: false,
              ),
            ),
            drawer: MaterialDrawer(currentPage: "Home"),
            body: Column(
              children: [
                // Envolver SelectionBar en un contenedor con tamaño adaptable
                Container(
                  height: screenSize.height *
                      0.08, // Altura adaptable basada en la pantalla
                  child: SelectionBar(
                      toggleLayout: toggleLayout, isReversed: isReversed),
                ),
                // Usar Expanded para que el contenido principal se adapte al espacio disponible
                Expanded(
                  child: isReversed ? TextToSign() : SignToText(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
