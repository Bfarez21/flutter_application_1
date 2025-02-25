import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        Uri.parse(
            '${dotenv.env['BASE_URL_DEV']}/api/usuarios/buscar/$googleId/'),
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
        Uri.parse('${dotenv.env['BASE_URL_DEV']}/api/usuarios/'),
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
                  image: AssetImage("assets/images/fondoLogin.png"),
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
          child: Center(
            // Añadido Center para mejorar el centrado
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0), // Aumentado el padding horizontal
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centrado vertical
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centrado horizontal
                  children: [
                    // Aumentado el espacio superior
                    Container(
                      height:
                          300, // Aumentado el tamaño del contenedor del logo
                      width: 500,
                      child: Center(
                        child: Image.asset(
                          'assets/images/imagotipo.png',
                          width: 500, // Aumentado el tamaño del logo
                          height: 500,
                        ),
                      ),
                    ),
                    SizedBox(height: 40), // Aumentado el espacio
                    Text(
                      'Inicia sesión',
                      style: TextStyle(
                        fontSize: 24, // Aumentado el tamaño de la fuente
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 50), // Aumentado el espacio
                    if (_isLoading)
                      Container(
                        height: 80, // Contenedor para el indicador de carga
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, // Ancho responsivo
                            height: 60, // Botones más altos
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 21, 83, 134),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 24), // Padding interno
                              ),
                              onPressed: () => _signInWithGoogle(context),
                              icon: Image.asset(
                                'assets/images/google.png',
                                height: 28, // Icono más grande
                              ),
                              label: Text(
                                'Iniciar sesión con Google',
                                style: TextStyle(
                                  fontSize: 18, // Texto más grande
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30), // Más espacio entre botones
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, // Ancho responsivo
                            height: 60, // Botones más altos
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 24), // Padding interno
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              },
                              icon: Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 28, // Icono más grande
                              ),
                              label: Text(
                                'Continuar como Invitado',
                                style: TextStyle(
                                  fontSize: 18, // Texto más grande
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 60), // Más espacio al final
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
