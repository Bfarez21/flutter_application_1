import 'usuario.dart';

class FeedbackModel {
  final String comentarioFee;
  final int calificacionFee;
  final DateTime fechaFee;
  final Usuario usuario;

  FeedbackModel({
    required this.comentarioFee,
    required this.calificacionFee,
    required this.fechaFee,
    required this.usuario,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      comentarioFee: json['comentario_fee'],
      calificacionFee: json['calificacion_fee'],
      fechaFee: DateTime.parse(json['fecha_fee']),
      usuario: Usuario.fromJson(json['fk_id_usu']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comentario_fee': comentarioFee,
      'calificacion_fee': calificacionFee,
      'fecha_fee': fechaFee.toIso8601String(),
      'fk_id_usu': usuario.toJson(),
    };
  }
}
