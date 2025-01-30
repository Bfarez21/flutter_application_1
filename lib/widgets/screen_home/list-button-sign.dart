import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ListButtonSign extends StatefulWidget {
  const ListButtonSign(
      {super.key, required this.isButtonSign, required this.onTextoEntered});

  final bool isButtonSign;
  final Function(String) onTextoEntered;

  @override
  State<ListButtonSign> createState() => _ListButtonSignState();
}

class _ListButtonSignState extends State<ListButtonSign> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Inicia o detiene el reconocimiento de voz
  void _listen() async {
    if (_isListening) {
      _speech.stop();
    } else {
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(onResult: (result) {
          setState(() {
            // _text = result.recognizedWords; // Transcribe el texto
            widget.onTextoEntered(result.recognizedWords);
          });
        });
      }
    }
    setState(() {
      _isListening = !_isListening; // Cambiar el estado de escucha
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isButtonSign ? buttonSign() : buttonText();
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
        icon:
            Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.grey),
        onPressed: () {
          // Acción del botón de audio.
          _listen();
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
