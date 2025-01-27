import 'usuario.dart';

class Perfil {
  final String nombrePer;
  final String descripcionPer;
  final Usuario usuario;

  Perfil({
    required this.nombrePer,
    required this.descripcionPer,
    required this.usuario,
  });

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      nombrePer: json['nombre_per'],
      descripcionPer: json['descripcion_per'],
      usuario: Usuario.fromJson(json['fk_id_usu']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_per': nombrePer,
      'descripcion_per': descripcionPer,
      'fk_id_usu': usuario.toJson(),
    };
  }
}
