import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
// screens
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/screens/settings.dart';
import 'package:flutter_application_1/screens/components.dart';
import 'package:flutter_application_1/screens/onboarding.dart';
import 'package:flutter_application_1/screens/signIn.dart';
import 'package:flutter_application_1/screens/Camera.dart';
import 'package:flutter_application_1/screens/Historial.dart';
import 'package:flutter_application_1/screens/crearCuenta.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Error inicializando Firebase: $e");
  }
  runApp(MaterialKitPROFlutter());
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
          apiKey: "AIzaSyBxRSkFdRBltJk0dVGrjC81Ep8Iu6FX8uA",
          authDomain: "signspeak-ai.firebaseapp.com",
          projectId: "signspeak-ai",
          storageBucket: "signspeak-ai.firebasestorage.app",
          messagingSenderId: "105200073019",
          appId: "1:105200073019:web:8547b604c1357ce4d35f1e");
    }
    return const FirebaseOptions(
      apiKey: "AIzaSyA_DjIChFuhrNY7hmp97Tnvt3liig3377U",
      appId: "1:105200073019:android:52d592e95936556ad35f1e",
      messagingSenderId: "105200073019",
      projectId: "signspeak-ai",
      storageBucket: "signspeak-ai.firebasestorage.app",
      androidClientId:
          "105200073019-41br8gloqnrtp0l9fk7tecl4e1qfrvmd.apps.googleusercontent.com",
    );
  }
}

class MaterialKitPROFlutter extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Traductor Lengua de Señas",
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si el usuario no está autenticado, mostrar onboarding
          if (!snapshot.hasData) {
            return Onboarding();
          }

          // Si el usuario está autenticado, mostrar home
          return Home();
        },
      ),
      routes: <String, WidgetBuilder>{
        "/onboarding": (BuildContext context) => Onboarding(),
        "/home": (BuildContext context) => Home(),
        "/components": (BuildContext context) => Components(),
        "/profile": (BuildContext context) => Profile(),
        "/settings": (BuildContext context) => Settings(),
        "/signin": (BuildContext context) => Login(),
        // "/camara": (BuildContext context) => Camara(),
        "/historial": (BuildContext context) => HistorialView(),
        "/crearCuenta": (BuildContext context) => CrearCuenta()
      },
    );
  }
}

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);
        return userCredential.user;
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        return userCredential.user;
      }
    } catch (e) {
      print("Error en el inicio de sesión con Google: $e");
      // Aquí podrías mostrar un snackbar o diálogo de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
  }
}
