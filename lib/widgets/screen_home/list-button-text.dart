import 'package:flutter/material.dart';

class ListButtonText extends StatelessWidget {
  const ListButtonText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up, color: Colors.grey),
          onPressed: () {
            // Acción del botón de sonido
          },
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.copy, color: Colors.grey),
              onPressed: () {
                // Acción del botón de compartir
              },
            ),
            IconButton(
              icon: Icon(Icons.bookmark, color: Colors.grey),
              onPressed: () {
                // Acción del botón de guardar
              },
            ),
          ],
        ),
      ],
    );
  }
}
