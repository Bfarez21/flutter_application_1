// gif_model.dart
class Gif {
  final int id;
  final String nombre;
  final String archivo;
  final int categoria;

  Gif({
    required this.id,
    required this.nombre,
    required this.archivo,
    required this.categoria,
  });

  factory Gif.fromJson(Map<String, dynamic> json) {
    return Gif(
      id: json['id'],
      nombre: json['nombre'],
      archivo: json['archivo'],
      categoria: json['categoria'],
    );
  }
}