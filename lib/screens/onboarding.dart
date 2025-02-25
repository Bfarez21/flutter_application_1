import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/Theme.dart';

class Onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/fondoInicio.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenido centrado en la parte inferior (texto + botón)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                  16.0, 32.0, 16.0, 32.0), // Reducido el padding horizontal

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Texto informativo
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
                    child: Column(
                      children: [
                        Text(
                          "Rompe Barreras, Conéctate con el Mundo 🌏",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "¡Bienvenido! Prepárate para comunicarte sin límites",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Esta app transforma el Lenguaje de Señas Ecuatoriano en texto y audio gracias a la IA.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Además, podrás medir y mejorar tus habilidades en la sección de aprendizaje y juegos.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "¡Comienza a explorar y expresarte de manera sencilla y divertida!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 120),

                  // Botón EMPEZAR
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 21, 83, 134),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signin');
                      },
                      child: Text(
                        "EMPEZAR",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Logo en la parte superior
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Image.asset(
                    'assets/images/imagotipo.png',
                    width: 300,
                    height: 300,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
