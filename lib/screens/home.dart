import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/Theme.dart';

//widgets
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/card-horizontal.dart';
import 'package:flutter_application_1/widgets/card-small.dart';
import 'package:flutter_application_1/widgets/card-square.dart';
import 'package:flutter_application_1/widgets/drawer.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (screenWidth - 48) / 2; // 48 = padding total (16*2 + 16 entre cards)

    return Scaffold(
      appBar: Navbar(
        title: "Traducctor",
        searchBar: false,
      ),
      backgroundColor: MaterialColors.bgColorScreen,
      drawer: MaterialDrawer(currentPage: "Home"),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card principal
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  height: 200, // Altura fija para el card principal
                  child: CardHorizontal(
                    cta: "Capturar Gestos",
                    title: "Activa la cámara para traducir",
                    img: 'assets/images/camera_capture.png',
                    tap: () {
                      Navigator.pushNamed(context, '/camara');
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Primera fila de cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: cardWidth,
                    height: 180, // Altura fija para cards pequeños
                    child: CardSmall(
                      cta: "Señas a Texto",
                      title: "Convierte lenguaje de señas a texto",
                      img: "assets/images/signs_to_text.png",
                      tap: () {
                        Navigator.pushNamed(context, '/signToText');
                      },
                    ),
                  ),
                  Container(
                    width: cardWidth,
                    height: 180,
                    child: CardSmall(
                      cta: "Texto a Señas",
                      title: "Muestra señas con un avatar",
                      img: "assets/images/text_to_signs.jpeg",
                      tap: () {
                        Navigator.pushNamed(context, '/textToSign');
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // Audio a Texto card centrado
              Center(
                child: Container(
                  width: cardWidth,
                  height: 180,
                  child: CardSmall(
                    cta: "Audio a Texto",
                    title: "Transcribe audio a texto",
                    img: "assets/images/audio_to_text.jpeg",
                    tap: () {
                      Navigator.pushNamed(context, '/audioToText');
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Card de historial
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Container(
                  height: 200, // Altura fija para el card cuadrado
                  child: CardSquare(
                    cta: "Historial",
                    title: "Consulta traducciones pasadas",
                    img: "assets/images/history.png",
                    tap: () {
                      Navigator.pushNamed(context, '/history');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
