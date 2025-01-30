import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Camera.dart';

class SignToText extends StatefulWidget {
  const SignToText({
    super.key,
  });

  @override
  _SignToTextState createState() => _SignToTextState();
}

class _SignToTextState extends State<SignToText> {
  String _textoReconocido = "Esperando detección...";

  void _actualizarTextoReconocido(String texto) {
    setState(() {
      _textoReconocido = texto;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20.0), // Mantén el margen lateral aquí
            child: Camara(
              onTextoDetectado: (texto) {
                _actualizarTextoReconocido(
                    texto); // Actualizas el texto detectado
              },
            ), // Camara se mantendrá ocupando todo el espacio
          ),
        ),
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
