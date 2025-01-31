import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/lenguage.dart';

class LanguajeBank extends StatefulWidget {
  const LanguajeBank({super.key});

  @override
  _LanguajeBankState createState() => _LanguajeBankState();
}

class _LanguajeBankState extends State<LanguajeBank> {
  String selectedLanguage = "Español";

  // Método para generar los items del dropdown
  List<DropdownMenuItem<String>> _buildLanguageDropdownItems() {
    return languageSign.map((language) {
      return DropdownMenuItem<String>(
        value: language["idioma"], // El valor será el idioma
        child: Text(
          language["idioma"]!,
          style: TextStyle(color: Color.fromRGBO(155, 163, 209, 1)),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLanguage,
      underline: SizedBox(),
      items: _buildLanguageDropdownItems(), // Genera los items desde la lista
      onChanged: (value) {
        // Cambiar el idioma seleccionado
        setState(() {
          selectedLanguage = value!;
        });
      },
    );
  }
}
