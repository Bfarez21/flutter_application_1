import 'package:flutter/material.dart';

import 'package:flutter_application_1/constants/Theme.dart';

//widgets
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/card-horizontal.dart';
import 'package:flutter_application_1/widgets/card-small.dart';
import 'package:flutter_application_1/widgets/card-square.dart';
import 'package:flutter_application_1/widgets/drawer.dart';
import 'package:flutter_application_1/widgets/input.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MaterialColors.bgColorScreen,
      appBar: Navbar(
        title: "Inicio de Sesión",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              CardSquare(
                title: "Bienvenido",
                cta: "",
                img: 'assets/images/user.png',
                tap: () {},
              ),
              SizedBox(height: 20),
              Input(
                placeholder: 'Correo electrónico',
                prefixIcon: Icon(Icons.email),
              ),
              SizedBox(height: 10),
              Input(
                placeholder: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
                obscuredText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 46, 169, 185),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Lógica de autenticación
                     Navigator.pushReplacementNamed(context, '/home');
                },
                child: Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Lógica de registro
                },
                child: Text(
                  'Crear una cuenta',
                  style: TextStyle(color: MaterialColors.primary),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  // Lógica para Google Sign-In
                },
                icon: Icon(Icons.login, color: Colors.white),
                label: Text(
                  'Inicia sesión con Google',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
