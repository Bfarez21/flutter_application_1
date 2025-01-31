import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category_model.dart'; // Importa el modelo de categoría
import '../models/gif_model.dart'; // Importa el modelo de GIF

class ApiService {
  static const String baseUrl = 'http://192.168.52.56:8000/api/';

  static Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('${baseUrl}categories/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    }
    throw Exception('Failed to load categories');
  }

  static Future<List<Gif>> getGifs() async {
    final response = await http.get(Uri.parse('${baseUrl}gifs/'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Gif.fromJson(json)).toList();
    }
    throw Exception('Failed to load gifs');
  }
}