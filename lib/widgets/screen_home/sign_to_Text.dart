import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Camera.dart';
import 'package:flutter_application_1/widgets/screen_home/list-button-text.dart';

class SignToText extends StatefulWidget {
  const SignToText({
    super.key,
  });

  @override
  _SignToTextState createState() => _SignToTextState();
}

class _SignToTextState extends State<SignToText> {
  String _textoReconocido = "";
  bool _isTextDetection = true;

  void _actualizarTextoReconocido(String texto) {
    setState(() {
      _textoReconocido = texto;
      _isTextDetection = false;
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
          child: Column(
            mainAxisSize: MainAxisSize.min, // Para que se ajuste al contenido
            children: [
              SizedBox(
                height: 120, // Altura del contenedor de texto
                child: Container(
                  alignment: Alignment
                      .topLeft, // Alinea el texto a la izquierda y arriba.
                  height: double
                      .infinity, // Ocupa toda la altura disponible del SizedBox
                  child: Text(
                    _textoReconocido.isNotEmpty
                        ? _textoReconocido
                        : "Esperando detección...",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              ListButtonText(
                textToTalk: _textoReconocido,
                isDetection: _isTextDetection,
              ),
            ],
          ),
        )
      ],
    );
  }
}
