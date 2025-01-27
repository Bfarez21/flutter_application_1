class Idioma {
  final String nombreIdi;
  final String codigoIdi;

  Idioma({
    required this.nombreIdi,
    required this.codigoIdi,
  });

  factory Idioma.fromJson(Map<String, dynamic> json) {
    return Idioma(
      nombreIdi: json['nombre_idi'],
      codigoIdi: json['codigo_idi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_idi': nombreIdi,
      'codigo_idi': codigoIdi,
    };
  }
}
