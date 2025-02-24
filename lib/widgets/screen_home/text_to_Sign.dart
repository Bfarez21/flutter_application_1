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
  String ingresoTexto = ""; // Movido fuera del build
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Agregar listener al controller
    _textController.addListener(() {
      setState(() {
        ingresoTexto = _textController.text;
      });
    });
  }

  void _actualizarTextoReconocido(String texto) {
    print("Actualizando texto reconocido: $texto"); // Debug print
    setState(() {
      textoReconocido = texto;
      ingresoTexto = texto;
      _textController.text = texto; // Actualizar el TextField
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
              controller: _textController, // Usar el controller
              onChanged: (value) {
                setState(() {
                  ingresoTexto = value;
                  textoReconocido = value;
                });
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
                    List<String> gifs =
                        TextToSignLogic.translateTextToGifs(ingresoTexto);
                    return gifs.isNotEmpty
                        ? Image.asset(
                            gifs.first,
                            width: 215,
                            height: 215,
                            fit: BoxFit.cover,
                          )
                        : Text(
                            "No se encontró traducción",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
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
      )
    ]);
  }
}
