import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //final String baseUrl = 'http://192.168.0.101:8000'; // Usa 10.0.2.2 si es un emulador Android
  final String baseUrl = 'http://192.168.52.41:8000';
  

  // Obtener usuarios
  Future<List<dynamic>> fetchUsuarios() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/usuarios/'))
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
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      ).timeout(Duration(seconds: 10));

      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }
}
