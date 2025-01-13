import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/constants/Theme.dart';

//widgets
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/card-horizontal.dart';
import 'package:flutter_application_1/widgets/card-small.dart';
import 'package:flutter_application_1/widgets/card-square.dart';
import 'package:flutter_application_1/widgets/drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  bool isReversed = false;

  void toggleLayout() {
    setState(() {
      isReversed = !isReversed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      appBar: Navbar(
        title: "Traductor",
        searchBar: false,
      ),
      drawer: MaterialDrawer(currentPage: "Home"),
      body: isReversed
          ? Column(
              children: [
                // Barra de selección invertida
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(30), // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Sombra ligera
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButton<String>(
                        value: "Sign",
                        underline:
                            SizedBox(), // Elimina la línea debajo del texto
                        items: [
                          DropdownMenuItem(
                            value: "Sign",
                            child: Text(
                              "Sign",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Español",
                            child: Text(
                              "Español",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          // Cambiar idioma
                        },
                      ),
                      GestureDetector(
                        onTap: toggleLayout,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.swap_horiz, color: Colors.white),
                        ),
                      ),
                      DropdownButton<String>(
                        value: "Español",
                        underline:
                            SizedBox(), // Elimina la línea debajo del texto
                        items: [
                          DropdownMenuItem(
                            value: "Sign",
                            child: Text(
                              "Sign",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Español",
                            child: Text(
                              "VLS",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          // Cambiar idioma
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                // Cuadro de texto
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                    ),
                    maxLines: 5, // Define el tamaño del cuadro de texto
                  ),
                ),
                // Imagen debajo del cuadro de texto
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.back_hand_rounded, // Icono de imagen
                      size: 150,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                // Barra de selección original
                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(30), // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Sombra ligera
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButton<String>(
                        value: "Español",
                        underline:
                            SizedBox(), // Elimina la línea debajo del texto
                        items: [
                          DropdownMenuItem(
                            value: "Sign",
                            child: Text(
                              "Sign",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Español",
                            child: Text(
                              "VLS",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          // Cambiar idioma
                        },
                      ),
                      GestureDetector(
                        onTap: toggleLayout,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.swap_horiz, color: Colors.white),
                        ),
                      ),
                      DropdownButton<String>(
                        value: "Sign",
                        underline:
                            SizedBox(), // Elimina la línea debajo del texto
                        items: [
                          DropdownMenuItem(
                            value: "Sign",
                            child: Text(
                              "Sign",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Español",
                            child: Text(
                              "Español",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          // Cambiar idioma
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 120,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                    height: 160, // Aumenté la altura del cuadro
                    child: Center(
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
