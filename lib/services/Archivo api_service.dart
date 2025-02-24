import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/historial_model.dart';
import '../models/usuariomodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static String baseUrl = dotenv.env['BASE_URL_DEV']!;

  // Obtener historial filtrado por usuario
  static Future<List<Historial>> getHistorial(String usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/historial/?usuario=$usuarioId'), // Filtro por usuario
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Historial.fromJson(json)).toList();
    }
    throw Exception('Failed to load historial');
  }
   // Nuevo método para eliminar un registro del historial
 static Future<void> deleteHistorial(int historialId) async {
  final user = FirebaseAuth.instance.currentUser;
  final idToken = await user?.getIdToken();
  
  final response = await http.delete(
    Uri.parse('$baseUrl/api/historial/$historialId/?usuario=${user?.uid}'),
    headers: {
      'Authorization': 'Bearer $idToken',
    },
  );
  
  if (response.statusCode == 204) {
    return;
  } else {
    throw Exception('Error al eliminar: ${response.body}');
  }
}


  // Obtener usuario por google_id
  static Future<Usuario> getUsuario(String googleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/usuarios/buscar/$googleId/'),
    );
    if (response.statusCode == 200) {
      return Usuario.fromJson(json.decode(response.body));
    }
    throw Exception('Usuario no encontrado');
  }

  // Guardar en historial
  static Future<void> guardarEnHistorial(int usuarioId, int gifId) async {
    try {
      String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (idToken == null) throw Exception('Usuario no autenticado');

      final url = Uri.parse('$baseUrl/api/historial/');
      print('Enviando POST a: $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: json.encode({'usuario': usuarioId, 'gif': gifId}),
      );

      print('Respuesta del servidor: ${response.statusCode} ${response.body}');

      if (response.statusCode == 201) return;

      if (response.statusCode == 400) {
        throw Exception('Datos inválidos: ${response.body}');
      } else {
        throw Exception('Error HTTP ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      print('Error de red: ${e.message}');
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      print('Error guardando en historial: $e');
      throw Exception('Error: $e');
    }
  }
}