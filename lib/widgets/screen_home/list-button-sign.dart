import 'package:flutter/material.dart';

class ListButtonSign extends StatelessWidget {
  const ListButtonSign({super.key, required this.isButtonSign});

  final bool isButtonSign;

  @override
  Widget build(BuildContext context) {
    return isButtonSign ? buttonSign() : buttonText();
  }

  Row buttonText() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IconButton(
        icon: Icon(Icons.draw, color: Colors.grey),
        onPressed: () {
          // Acción del botón de dibujo.
        },
      ),
      IconButton(
        icon: Icon(Icons.mic, color: Colors.grey),
        onPressed: () {
          // Acción del botón de audio.
        },
      )
    ]);
  }

  Container buttonSign() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Sombra ligera
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        IconButton(
          icon: Icon(Icons.download, color: Colors.grey),
          onPressed: () {
            // Acción del botón de dibujar
          },
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.grey),
          onPressed: () {
            // Acción del botón de audio
          },
        ),
        IconButton(
          icon: Icon(Icons.bookmark, color: Colors.grey),
          onPressed: () {
            // Acción del botón de audio
          },
        )
      ]),
    );
  }
}
