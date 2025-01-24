import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/screen_home/language-bank.dart';

class SelectionBar extends StatelessWidget {
  const SelectionBar(
      {super.key, required this.toggleLayout, required this.isReversed});

  final VoidCallback toggleLayout;
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: Center(child: isReversed ? LanguajeBank() : Text("SIGN"))),
          Expanded(
              child: Center(
                  child: GestureDetector(
            onTap: toggleLayout,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.swap_horiz, color: Colors.white),
            ),
          ))),
          Expanded(
              child: Center(child: isReversed ? Text("SIGN") : LanguajeBank()))
        ],
      ),
    );
  }
}
