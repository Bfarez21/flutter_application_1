import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Camera.dart';
import 'package:flutter_application_1/widgets/screen_home/list-button-sign.dart';
import 'package:flutter_application_1/widgets/screen_home/list-button-text.dart';
import 'package:flutter_application_1/widgets/screen_home/optionTraslate.dart';
import 'package:flutter_application_1/widgets/screen_home/sign-language-keyboard.dart';

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
  bool isReversed = false;

  void _actualizarTextoReconocido(String texto) {
    setState(() {
      _textoReconocido = texto;
      _isTextDetection = false;
    });
  }

  void toggleLayout() {
    setState(() {
      isReversed = !isReversed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isReversed
            ? Expanded(
                child: Camara(
                  onTextoDetectado: (texto) {
                    _actualizarTextoReconocido(texto);
                  },
                  toggleLayout: toggleLayout,
                ),
              )
            : SignLanguageInput(
                onTextoDetectado: (texto) {
                  _actualizarTextoReconocido(texto);
                },
                toggleLayout: toggleLayout,
              ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF151827),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Para que se ajuste al contenido
            children: [
              SizedBox(
                height: 100, // Altura del contenedor de texto
                child: Container(
                  alignment: Alignment
                      .topLeft, // Alinea el texto a la izquierda y arriba.
                  height: double
                      .infinity, // Ocupa toda la altura disponible del SizedBox
                  child: Text(
                    _textoReconocido.isNotEmpty
                        ? _textoReconocido
                        : "Esperando detección...",
                    style: TextStyle(
                        color: Color.fromRGBO(155, 163, 209, 1), fontSize: 16),
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
