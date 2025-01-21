import 'package:flutter_application_1/constants/signLenguageData.dart';

class TextToSignLogic {
  /// Traduce el texto ingresado a una lista de rutas de GIFs correspondientes.
  /// Prioriza frases completas y luego palabras individuales.
  static List<String> translateTextToGifs(String text) {
    if (text.isEmpty) return [];

    List<String> signs = [];
    String cleanedText = text.toUpperCase().trim();

     // Norm aliza el texto para la búsqueda directa  
  String normalizedText = cleanedText[0].toUpperCase() + cleanedText.substring(1).toLowerCase();  

    // Busca directamente la frase completa en los datos
    if (SignLanguageData.signGifs.containsKey(normalizedText)) {
      signs.add(SignLanguageData.signGifs[normalizedText]!);
    } else {
      // Si no encuentra la frase completa, divide en palabras
      List<String> words = cleanedText.split(' ');

      for (String word in words) {
        if (SignLanguageData.signGifs.containsKey(word)) {
          signs.add(SignLanguageData.signGifs[word]!);
        } else {
          // Si no encuentra la palabra, divide en letras
          /*for (String letter in word.split('')) {
            if (SignLanguageData.signGifs.containsKey(letter)) {
              signs.add(SignLanguageData.signGifs[letter]!);
            }
          }*/
        }
      }
    }

    return signs;
  }
}
