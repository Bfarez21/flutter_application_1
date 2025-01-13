import 'package:flutter/material.dart';

class PhotoAlbum extends StatelessWidget {
  final List<String> textos = [
    "Hola...",
    "Gracias",
    "Sí",
    "No",
    "Por favor",
    "Ayuda",
    "Casa",
    "Adiós",
    "Hospital",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Text(
          "Traducciones recientes",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            decoration: TextDecoration.underline,
          ),
        ),
        SizedBox(height: 10),
        // Grid con los elementos
        SizedBox(
          height: 250,
          child: GridView.count(
            primary: false,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: textos
                .map((texto) => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Center(
                        child: Text(
                          texto,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
