import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign In
  Future<void> handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      print('Se produjo un error al autenticarse: $e');
    }
  }

  // Obtener datos del usuario autenticado
  Map<String, String>? getUserInfo() {
    final user = _auth.currentUser;
    if (user != null) {
      return {
        'nombre': user.displayName ?? '',
        'correo': user.email ?? '',
        'foto': user.photoURL ?? '',
      };
    }
    return null; // Usuario no autenticado
  }

  // Google Sign Out
  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
