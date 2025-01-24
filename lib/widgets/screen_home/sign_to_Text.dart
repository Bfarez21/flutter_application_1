import 'package:flutter/material.dart';

class SignToText extends StatefulWidget {
  const SignToText({
    super.key,
  });

  @override
  _SignToTextState createState() => _SignToTextState();
}

class _SignToTextState extends State<SignToText> {
  String _textoReconocido = "Esperando detección...";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /*Expanded(
          child: Center(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0), // Espacio lateral

            child: Camara(
              onRecognition: (texto) {
                setState(() {
                  _textoReconocido = texto; // Actualiza el texto detectado
                });
              },
            ),
          )),
        ),*/
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            height: 160,
            child: Center(
              child: Text(
                _textoReconocido,
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );
  }
}
