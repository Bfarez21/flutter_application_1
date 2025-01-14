import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
import 'package:flutter_application_1/screens/crearCuenta.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialKitPROFlutter());
}

class MaterialKitPROFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Traductor Lengua de Señas", // titulo
        debugShowCheckedModeBanner: false,
        initialRoute: "/onboarding", //vista principal
        routes: <String, WidgetBuilder>{
          "/onboarding": (BuildContext context) => new Onboarding(),
          "/home": (BuildContext context) => new Home(),
          "/components": (BuildContext context) => new Components(),
          "/profile": (BuildContext context) => new Profile(),
          "/settings": (BuildContext context) => new Settings(),
          "/signin": (BuildContext context) => new Login(),
          "/camara": (BuildContext context) => new Camara(),
          "/historial": (BuildContext context) => new HistorialView(),
          "/crearCuenta": (BuildContext context) => new CrearCuenta()
        });
  }
}
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Instancia de GoogleSignIn

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      if (account != null) {
        // Usuario autenticado
        Navigator.pushReplacementNamed(context, "/home"); // Redirigir a Home
      }
    });
    _googleSignIn.signInSilently(); // Intentar iniciar sesión si hay sesión guardada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _googleSignIn.onCurrentUserChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          }
          if (_googleSignIn.currentUser != null) {
            return Home(); // Si ya está autenticado
          } else {
            return Login(); // Si no está autenticado
          }
        },
      ),
    );
  }
}
