import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Iniciar sesión con Google
  Future<User?> handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Si el usuario cancela el login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error al autenticarse con Google: $e');
      return null;
    }
  }

  // Obtener datos del usuario autenticado
  Map<String, String>? getUserInfo() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return {
          'nombre': user.displayName ?? '',
          'correo': user.email ?? '',
          'foto': user.photoURL ?? '',
        };
      }
      return null; // Usuario no autenticado
    } catch (e) {
      print('Error al obtener la información del usuario: $e');
      return null;
    }
  }

  // Cerrar sesión de Google y Firebase
  Future<void> handleSignOut() async {
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
      await _auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
