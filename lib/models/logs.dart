import 'usuario.dart';

class Logs {
  final String mensajeLog;
  final DateTime fechaLog;
  final bool leidoLog;
  final Usuario usuario;

  Logs({
    required this.mensajeLog,
    required this.fechaLog,
    required this.leidoLog,
    required this.usuario,
  });

  factory Logs.fromJson(Map<String, dynamic> json) {
    return Logs(
      mensajeLog: json['mensaje_log'],
      fechaLog: DateTime.parse(json['fecha_log']),
      leidoLog: json['leido_log'],
      usuario: Usuario.fromJson(json['fk_id_usu']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mensaje_log': mensajeLog,
      'fecha_log': fechaLog.toIso8601String(),
      'leido_log': leidoLog,
      'fk_id_usu': usuario.toJson(),
    };
  }
}
