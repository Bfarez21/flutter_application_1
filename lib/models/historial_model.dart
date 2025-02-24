class Historial {
  final int id;
  final String gifNombre;
  final String categoriaNombre;
  final String fechaHora;
  final String gifUrl;

  Historial({
    required this.id,
    required this.gifNombre,
    required this.categoriaNombre,
    required this.fechaHora,
    required this.gifUrl,
  });

  factory Historial.fromJson(Map<String, dynamic> json) {
    return Historial(
      id: json['id'],
      gifNombre: json['gif_nombre'],
      categoriaNombre: json['categoria_nombre'],
      fechaHora: json['fecha_hora'],
      gifUrl: json['gif_url'],
    );
  }
}