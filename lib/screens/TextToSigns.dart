// TextToSigns.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/signLenguageData.dart';
import 'package:flutter_application_1/constants/text_to_sign.dart';

class TextToSigns extends StatefulWidget {
  final String type;

  const TextToSigns({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  _TextToSignsState createState() => _TextToSignsState();
}

class _TextToSignsState extends State<TextToSigns> {
  String ingresoTexto = '';
  List<SignItem> availableSigns = [];

  @override
  void initState() {
    super.initState();
    availableSigns = SignLanguageData.getSignsByType(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Señas de ${widget.type.toUpperCase()}",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  ingresoTexto = text;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresa una ${widget.type}',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ingresoTexto.isNotEmpty
                  ? Builder(
                      builder: (context) {
                        // Buscar el signo correspondiente al tipo actual
                        SignItem? sign = SignLanguageData.findSignByWord(
                            ingresoTexto, widget.type);

                        if (sign != null) {
                          return Image.asset(
                            sign.gifPath,
                            width: 215,
                            height: 215,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Text(
                            "No se encontró ${widget.type} con esa palabra",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.7)),
                          );
                        }
                      },
                    )
                  : Container(
                      child: Text(
                        "Ingresa una ${widget.type} para ver su seña",
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
            ),
          ),
          // Lista de palabras disponibles para el tipo seleccionado
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableSigns.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ActionChip(
                    label: Text(availableSigns[index].word),
                    onPressed: () {
                      setState(() {
                        ingresoTexto = availableSigns[index].word;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
