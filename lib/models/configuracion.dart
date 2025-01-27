class Configuracion {
  final String idiomaCon;
  final String configuracionAudioCon;
  final String configuracionTextoCon;

  Configuracion({
    required this.idiomaCon,
    required this.configuracionAudioCon,
    required this.configuracionTextoCon,
  });

  factory Configuracion.fromJson(Map<String, dynamic> json) {
    return Configuracion(
      idiomaCon: json['idioma_con'],
      configuracionAudioCon: json['configuracionAudio_con'],
      configuracionTextoCon: json['configuracionTexto_con'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idioma_con': idiomaCon,
      'configuracionAudio_con': configuracionAudioCon,
      'configuracionTexto_con': configuracionTextoCon,
    };
  }
}
