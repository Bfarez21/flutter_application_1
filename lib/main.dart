import 'package:flutter/material.dart';

// screens
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/screens/settings.dart';
import 'package:flutter_application_1/screens/components.dart';
import 'package:flutter_application_1/screens/onboarding.dart';
import 'package:flutter_application_1/screens/signIn.dart';
// vistas navegacion
import 'package:flutter_application_1/screens/Camera.dart';
import 'package:flutter_application_1/screens/Historial.dart';
void main() => runApp(MaterialKitPROFlutter());

class MaterialKitPROFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Traductor Lengua de Señas", // titulo 
        debugShowCheckedModeBanner: false,
        initialRoute: "/onboarding",  //vista principal
        routes: <String, WidgetBuilder>{
          "/onboarding": (BuildContext context) => new Onboarding(),
          "/home": (BuildContext context) => new Home(),
          "/components": (BuildContext context) => new Components(),
          "/profile": (BuildContext context) => new Profile(),
          "/settings": (BuildContext context) => new Settings(),
          "/signin": (BuildContext context) => new Login(),
          "/camara":(BuildContext context) => new Camara(),
          "/historial": (BuildContext context) => new HistorialView()
        });
        
  }
}
