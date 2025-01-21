import 'package:flutter/material.dart';

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
    'Lunes':'assets/gifs/diasSemana/lunes.gif',
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
    "type" : "dias" 
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
    "type": "interrogantes"  
  },
   {  
    "img": AssetImage("assets/images/profesiones.jpg"),  
    "title": "GIF 5",  
    "description": "Signs for professions",
    "type": "profesiones"  
  },
];
}