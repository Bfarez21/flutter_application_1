import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/category_model.dart'; // Importa el modelo de categoría
import '../models/gif_model.dart'; // Importa el modelo de GIF

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL_DEV']!;

  // Obtener usuarios
  Future<List<dynamic>> fetchUsuarios() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/usuarios/'))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al cargar usuarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear usuario
  Future<bool> createUsuario(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/usuarios/'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(data),
          )
          .timeout(Duration(seconds: 10));

      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }
}
