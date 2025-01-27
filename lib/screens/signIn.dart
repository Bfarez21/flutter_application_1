import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();
  bool _isLoading = false; // Estado para mostrar el indicador de carga

  // Función para iniciar sesión con Google
  Future<void> _signInWithGoogle(BuildContext context) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      User? user = await _authService.handleSignIn();
      if (user != null) {
        String googleId = user.uid;

        bool isUserRegistered = await _checkIfUserExists(googleId);
        if (!isUserRegistered) {
          bool registrationSuccess = await _registerUser(googleId);
          if (!registrationSuccess) {
            // No redirigir si el registro falló
            return;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'El usuario ya está registrado.',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(16),
            ),
          );
        }

        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Verificar si el usuario ya está registrado en el backend
  Future<bool> _checkIfUserExists(String googleId) async {
    try {
      final response = await http.get(
        //Se debe poner la dirección IP de la máquina donde se ejecuta el backend
        //Uri.parse('http://192.168.0.101:8000/api/usuarios/buscar/$googleId/'),//Isaac
        Uri.parse('http://192.168.52.41:8000/api/usuarios/buscar/$googleId/'),//TEC_EP_202
      );

      if (response.statusCode == 200) {
        return true; // Usuario ya registrado
      } else if (response.statusCode == 404) {
        return false; // Usuario no existe
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al verificar el usuario.')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white), // Ícono de error
              SizedBox(width: 10), // Espacio entre el ícono y el texto
              Expanded(
                child: Text(
                  'Error de conexión. Inténtalo de nuevo.',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red, // Fondo rojo para errores
          behavior: SnackBarBehavior.floating, // Hace que el snackbar flote
          duration: Duration(seconds: 5), // Duración del mensaje
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Bordes redondeados
          ),
          margin: EdgeInsets.all(16), // Margen alrededor del snackbar
        ),
      );

      return false;
    }
  }

  // Registrar al usuario en el backend
  Future<bool> _registerUser(String googleId) async {
    try {
      final response = await http.post(
        //Uri.parse('http://192.168.0.101:8000/api/usuarios/'),
        Uri.parse('http://192.168.52.41:8000/api/usuarios/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'google_id': googleId}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Usuario registrado con éxito. Bienvenido!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al registrar usuario.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo conectar con el servidor.')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: MediaQuery.of(context).size.width <= 600
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/fondoManos.png"),
                  fit: BoxFit.cover,
                ),
              )
            : BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1E88E5), Color(0xFF1976D2)],
                ),
              ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'SignSpeak AI',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.sign_language,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Inicia sesión',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 21, 83, 134),
                              side: BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () => _signInWithGoogle(context),
                            icon: Image.asset(
                              'assets/images/google.png',
                              height: 24,
                            ),
                            label: Text(
                              'Iniciar sesión con Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              side: BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                            icon: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Continuar como Invitado',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
