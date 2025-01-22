import 'package:flutter/material.dart';

class SignItem {
  final String gifPath;
  final String word;
  final String type;

  SignItem({
    required this.gifPath,
    required this.word,
    required this.type,
  });
}

class SignLanguageData {
  static final Map<String, String> signGifs = {
    // Letras
    'A': 'assets/gifs/letras/A.gif',
    'B': 'assets/gifs/letras/B.gif',
    //'C': 'assets/gifs/letters/c.gif',
    // Números
    '1': 'assets/gifs/numeros/1.gif',
    '2': 'assets/gifs/numeros/2.gif',
    '3': 'assets/gifs/numeros/3.gif',
    '4': 'assets/gifs/numeros/4.gif',
    '5': 'assets/gifs/numeros/5.gif',
    '6': 'assets/gifs/numeros/6.gif',
    '7': 'assets/gifs/numeros/7.gif',
    '8': 'assets/gifs/numeros/8.gif',
    '9': 'assets/gifs/numeros/9.gif',
    '10': 'assets/gifs/numeros/10.gif',

    // Dias Semana
    'Lunes': 'assets/gifs/diasSemana/lunes.gif',
    'Martes': 'assets/gifs/diasSemana/martes.gif',
    'Miercoles': 'assets/gifs/diasSemana/miercoles.gif',
    'Jueves': 'assets/gifs/diasSemana/jueves.gif',
    'Viernes': 'assets/gifs/diasSemana/viernes.gif',
    'Sábado': 'assets/gifs/diasSemana/sabado.gif',
    'Domingo': 'assets/gifs/diasSemana/domingo.gif',

    // Palabras comunes
    'HOLA': 'assets/gifs/palabras/hola.gif',
    'DORMIR': 'assets/gifs/palabras/dormir.gif',
    'BUENOS DIAS': 'assets/gifs/frasesComunes/buenosDias.gif',
    'BUENAS TARDES': 'assets/gifs/frasesComunes/buenasTardes.gif',
    'BUENAS NOCHES': 'assets/gifs/frasesComunes/buenasNoches.gif',
  };

  static final Set<String> commonWords = {
    'HOLA',
    'GRACIAS',
    'ADIOS',
    'POR FAVOR',
  };

  // Datos de ejemplo para el Sider-carrusel
  static final List<Map<String, dynamic>> exampleImages = [
    {
      "img": AssetImage("assets/images/fondoManos.png"),
      "title": "GIF 1",
      "description": "Sign for A"
    },
    {
      "img": AssetImage("assets/images/user.png"),
      "title": "GIF 2",
      "description": "Sign for B"
    },
    {
      "img": AssetImage("assets/images/text_to_signs.jpeg"),
      "title": "GIF 3",
      "description": "Sign for C"
    },
  ];

  // Datos de ejemplo para el Sider-carrusel vertical category
  static final List<Map<String, dynamic>> categoryImages = [
    {
      "img": AssetImage("assets/images/numeros.png"),
      "title": "GIF 1",
      "description": "Signs for numbers",
      "type": "numero"
    },
    {
      "img": AssetImage("assets/images/diasSemana.jpeg"),
      "title": "GIF 2",
      "description": "Signs for days",
      "type": "dias"
    },
    {
      "img": AssetImage("assets/images/colores.png"),
      "title": "GIF 3",
      "description": "Signs for Colors",
      "type": "colores"
    },
    {
      "img": AssetImage("assets/images/preguntas.jpg"),
      "title": "GIF 4",
      "description": "Signs for questions",
      "type": "preguntas"
    },
    {
      "img": AssetImage("assets/images/profesiones.jpg"),
      "title": "GIF 5",
      "description": "Signs for professions",
      "type": "profesiones"
    },
  ];

  /// card por tipo
  static final Map<String, List<SignItem>> signsByType = {
    'numero': [
      SignItem(
        gifPath: 'assets/gifs/numeros/1.gif',
        word: 'uno',
        type: 'numero',
      ),
      SignItem(
        gifPath: 'assets/gifs/numeros/2.gif',
        word: 'dos',
        type: 'numero',
      ),
      SignItem(
        gifPath: 'assets/gifs/numeros/3.gif',
        word: 'tres',
        type: 'numero',
      ),
      SignItem(
        gifPath: 'assets/gifs/numeros/4.gif',
        word: 'cuatro',
        type: 'numero',
      ),
      SignItem(
        gifPath: 'assets/gifs/numeros/5.gif',
        word: 'cinco',
        type: 'numero',
      ),
      SignItem(
        gifPath: 'assets/gifs/numeros/6.gif',
        word: 'seis',
        type: 'numero',
      ),
      SignItem(
        gifPath: 'assets/gifs/numeros/7.gif',
        word: 'siete',
        type: 'numero',
      ),
      SignItem(
        gifPath: 'assets/gifs/numeros/8.gif',
        word: 'ocho',
        type: 'numero',
      ),
      SignItem(
        gifPath: 'assets/gifs/numeros/9.gif',
        word: 'nueve',
        type: 'numero',
      ),
      SignItem(
        gifPath: 'assets/gifs/numeros/10.gif',
        word: 'diez',
        type: 'numero',
      ),
      // Agregar más números
    ],
    'dias': [
      SignItem(
        gifPath: 'assets/gifs/diasSemana/lunes.gif',
        word: 'lunes',
        type: 'dias',
      ),
      SignItem(
        gifPath: 'assets/gifs/diasSemana/martes.gif',
        word: 'martes',
        type: 'dias',
      ),
      SignItem(
        gifPath: 'assets/gifs/diasSemana/miercoles.gif',
        word: 'miercoles',
        type: 'dias',
      ),
      SignItem(
        gifPath: 'assets/gifs/diasSemana/jueves.gif',
        word: 'jueves',
        type: 'dias',
      ),
      SignItem(
        gifPath: 'assets/gifs/diasSemana/viernes.gif',
        word: 'viernes',
        type: 'dias',
      ),
      SignItem(
        gifPath: 'assets/gifs/diasSemana/sabado.gif',
        word: 'sabado',
        type: 'dias',
      ),
      SignItem(
        gifPath: 'assets/gifs/diasSemana/domingo.gif',
        word: 'domingo',
        type: 'dias',
      ),
      // Agregar más días
    ],
    'colores': [
      SignItem(
        gifPath: 'assets/gifs/colores/rojo.gif',
        word: 'rojo',
        type: 'colores',
      ),
       SignItem(
        gifPath: 'assets/gifs/colores/azul.gif',
        word: 'azul',
        type: 'colores',
      ),
       SignItem(
        gifPath: 'assets/gifs/colores/blanco.gif',
        word: 'blanco',
        type: 'colores',
      ),
       SignItem(
        gifPath: 'assets/gifs/colores/negro.gif',
        word: 'negro',
        type: 'colores',
      ),
      // Agregar más colores
    ],
    'preguntas': [
      SignItem(
        gifPath: 'assets/gifs/interrogativos/quien.gif',
        word: 'Quien',
        type: 'preguntas',
      ),
      SignItem(
        gifPath: 'assets/gifs/interrogativos/como.gif',
        word: 'Como',
        type: 'preguntas',
      ),
      SignItem(
        gifPath: 'assets/gifs/interrogativos/cuando.gif',
        word: 'Cuando',
        type: 'preguntas',
      ),
      SignItem(
        gifPath: 'assets/gifs/interrogativos/donde.gif',
        word: 'Donde',
        type: 'preguntas',
      ),
      SignItem(
        gifPath: 'assets/gifs/interrogativos/porque.gif',
        word: 'Porque',
        type: 'preguntas',
      ),
      SignItem(
        gifPath: 'assets/gifs/interrogativos/que.gif',
        word: 'Que',
        type: 'preguntas',
      ),
      // Agregar más preguntas
    ],
    'profesiones': [
      SignItem(
        gifPath: 'assets/gifs/profesiones/abogadoa.gif',
        word: 'Abogado',
        type: 'profesiones',
      ),
      SignItem(
        gifPath: 'assets/gifs/profesiones/docente.gif',
        word: 'Docente',
        type: 'profesiones',
      ),
      SignItem(
        gifPath: 'assets/gifs/profesiones/enfermera.gif',
        word: 'Enfermera',
        type: 'profesiones',
      ),
      SignItem(
        gifPath: 'assets/gifs/profesiones/estudiante.gif',
        word: 'Estudiante',
        type: 'profesiones',
      ),
      SignItem(
        gifPath: 'assets/gifs/profesiones/ingeniero.gif',
        word: 'Ingeniero',
        type: 'profesiones',
      ),
      // Agregar más profesiones
    ],
  };

  static List<SignItem> getSignsByType(String type) {
    return signsByType[type] ?? [];
  }

  static SignItem? findSignByWord(String word, String type) {
    final signs = signsByType[type] ?? [];
    return signs.cast<SignItem?>().firstWhere(
          (sign) => sign?.word.toLowerCase() == word.toLowerCase(),
          orElse: () => null,
        );
  }
}
