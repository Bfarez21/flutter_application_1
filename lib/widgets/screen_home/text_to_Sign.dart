import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/text_to_sign.dart';
import 'package:flutter_application_1/widgets/screen_home/list-button-sign.dart';

class TextToSign extends StatefulWidget {
  const TextToSign({super.key});

  @override
  _TextToSignState createState() => _TextToSignState();
}

class _TextToSignState extends State<TextToSign> {
  String textoReconocido = "";
  String ingresoTexto = "";
  final TextEditingController _textController = TextEditingController();
  List<String> gifsTraducidos = [];
  String? currentGifPath; // Añadido para mantener la ruta del GIF actual

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        ingresoTexto = _textController.text;
      });
    });
  }

  void _actualizarTextoReconocido(String texto) {
    print("Actualizando texto reconocido: $texto");
    setState(() {
      textoReconocido = texto;
      ingresoTexto = texto;
      _textController.text = texto;
    });
  }

  Future<void> _actualizarGifsTraducidos(String texto) async {
    setState(() {
      gifsTraducidos = TextToSignLogic.translateTextToGifs(texto);
      if (gifsTraducidos.isNotEmpty) {
        currentGifPath = gifsTraducidos.first;
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF151827),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              TextField(
                controller: _textController,
                onChanged: (value) async {
                  setState(() {
                    ingresoTexto = value;
                    textoReconocido = value;
                  });
                  await _actualizarGifsTraducidos(value);
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Escribe aquí...',
                  hintStyle: TextStyle(color: Color.fromRGBO(155, 163, 209, 1)),
                ),
                style: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                maxLines: 3,
              ),
              ListButtonSign(
                isButtonSign: false,
                onTextoEntered: _actualizarTextoReconocido,
              )
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: ingresoTexto.isNotEmpty
                ? FutureBuilder<Widget>(
                    future: Future(() {
                      return gifsTraducidos.isNotEmpty
                          ? Image.asset(
                              gifsTraducidos.first,
                              width: 215,
                              height: 215,
                              fit: BoxFit.cover,
                            )
                          : Text(
                              "No se encontró traducción",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7)),
                            );
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      }
                      return const CircularProgressIndicator();
                    },
                  )
                : Container(
                    child: Text(
                      "Ingresa una palabra para ver",
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
          ),
        ),
        ListButtonSign(
          isButtonSign: true,
          onTextoEntered: _actualizarTextoReconocido,
          gifsTraducidos: gifsTraducidos,
          currentText: ingresoTexto, // Pasar el texto actual
        )
      ],
    );
  }
}
