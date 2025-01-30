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

  void _actualizarTextoReconocido(String texto) {
    setState(() {
      textoReconocido = texto;
    });
  }

  @override
  Widget build(BuildContext context) {
    String ingresoTexto = "";

    return Column(children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => textoReconocido,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Escribe aquí...',
              ),
              maxLines: 3,
            ),
            ListButtonSign(
                isButtonSign: false,
                onTextoEntered: (texto) {
                  _actualizarTextoReconocido(
                      texto); // Actualizas el texto detectado
                })
          ],
        ),
      ),

      /// Agregar el carrusel debajo del TextField
      // ProductCarousel(imgArray: SignLanguageData.exampleImages),
      Expanded(
        child: Center(
          child: ingresoTexto.isNotEmpty
              ? FutureBuilder<Widget>(
                  future: Future(() {
                    List<String> gifs =
                        TextToSignLogic.translateTextToGifs(ingresoTexto);
                    // Por ahora mostraremos solo el primer GIF
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
                    return CircularProgressIndicator();
                  },
                )
              : Container(
                  child: Text(
                    "Ingresa una palabra para ver ",
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ),
        ),
      ),
      ListButtonSign(
          isButtonSign: true,
          onTextoEntered: (texto) {
            _actualizarTextoReconocido(texto); // Actualizas el texto detectado
          })
    ]);
  }
}
