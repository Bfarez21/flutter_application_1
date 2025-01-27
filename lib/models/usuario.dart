import 'configuracion.dart';

class Usuario {
  final String googleId;
  final Configuracion configuracion;

  Usuario({
    required this.googleId,
    required this.configuracion,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      googleId: json['google_id'],
      configuracion: Configuracion.fromJson(json['fk_id_con']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'google_id': googleId,
      'fk_id_con': configuracion.toJson(),
    };
  }
}
