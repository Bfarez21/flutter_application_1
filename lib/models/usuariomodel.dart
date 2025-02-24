class Usuario {
  final int id;
  final String googleId;

  Usuario({required this.id, required this.googleId});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      googleId: json['google_id'],
    );
  }
}