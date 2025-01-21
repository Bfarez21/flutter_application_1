// TextToSigns.dart  

import 'package:flutter/material.dart';  
import 'package:flutter_application_1/constants/signLenguageData.dart';
import 'package:flutter_application_1/constants/text_to_sign.dart';

class TextToSigns extends StatefulWidget {  
  @override  
  _TextToSignsState createState() => _TextToSignsState();  
}  

class _TextToSignsState extends State<TextToSigns> {  
  String ingresoTexto = '';  

  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(
       title: const Text(
          "Texto a Lengua de Señas",
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
                hintText: 'Ingresa una palabra',  
                filled: true,  
                fillColor: Colors.white,  
              ),  
            ),  
          ),  
          Expanded(  
            child: Center(  
              child: ingresoTexto.isNotEmpty  
                  ? FutureBuilder<Widget>(  
                      future: Future(() {  
                        List<String> gifs = TextToSignLogic.translateTextToGifs(
                                      ingresoTexto); 
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
                                style: TextStyle(color: Colors.black.withOpacity(0.7)),  
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
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),  
                      ),  
                    ),  
            ),  
          ),  
        ],  
      ),  
    );  
  }  
}