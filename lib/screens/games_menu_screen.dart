import 'package:flutter/material.dart';
import 'simon_says_screen.dart';
import 'unlock_game_screen.dart';

class GamesMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de la aplicación con diseño similar al de CategoriesScreen
      appBar: _buildAppBar(),
      // Cuerpo de la pantalla con un fondo degradado
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E), // Azul oscuro
              Color(0xFF16213E), // Azul más oscuro
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          // Columna que organiza los botones de los juegos
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centra los botones verticalmente
            children: <Widget>[
              // Botón para el juego "Simón dice con GIF"
              _buildGameButton(
                context: context,
                title: "Simón dice con GIF",
                imagePath: "assets/images/memorizate.jpg",
                destination: SimonSaysScreen(),
              ),
              SizedBox(height: 10), // Espacio reducido entre los botones
              // Botón para el juego "Encuentra las señas iguales"
              _buildGameButton(
                context: context,
                title: "Encuentra las señas iguales",
                imagePath: "assets/images/paress.jpg",
                destination: UnlockGameScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir el AppBar con diseño similar al de CategoriesScreen
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "SignSpeak Juegos",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black54,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
            TextSpan(
              text: "\nDiviértete aprendiendo",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)], // Degradado oscuro
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 5,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  // Método para construir un botón de juego personalizado
  Widget _buildGameButton({
    required BuildContext context,
    required String title,
    required String imagePath,
    required Widget destination,
  }) {
    return InkWell(
      onTap: () {
        // Navega a la pantalla de destino cuando se toca el botón
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.blue.withOpacity(0.5), // Color del efecto de toque
      hoverColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15, // Altura del botón
        width: double.infinity, // Ancho del botón (toda la pantalla)
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath), // Imagen de fondo del botón
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.withOpacity(0.2),
              Colors.indigo.withOpacity(0.4),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Capa de degradado para mejorar la visibilidad del texto
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Texto centrado en el botón
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}