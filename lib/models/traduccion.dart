import 'usuario.dart';
import 'idioma.dart';

class Traduccion {
  final String textoTra;
  final DateTime fechaTra;
  final Usuario usuario;
  final List<Idioma> idiomas;

  Traduccion({
    required this.textoTra,
    required this.fechaTra,
    required this.usuario,
    required this.idiomas,
  });

  factory Traduccion.fromJson(Map<String, dynamic> json) {
    return Traduccion(
      textoTra: json['texto_tra'],
      fechaTra: DateTime.parse(json['fecha_tra']),
      usuario: Usuario.fromJson(json['fk_id_usu']),
      idiomas: (json['fk_id_idi'] as List).map((i) => Idioma.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'texto_tra': textoTra,
      'fecha_tra': fechaTra.toIso8601String(),
      'fk_id_usu': usuario.toJson(),
      'fk_id_idi': idiomas.map((i) => i.toJson()).toList(),
    };
  }
}
