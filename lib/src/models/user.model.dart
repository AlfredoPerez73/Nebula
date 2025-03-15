class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String nivelExperiencia;
  final double peso;
  final double altura;
  final String objetivo;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.nivelExperiencia,
    required this.peso,
    required this.altura,
    required this.objetivo,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,
      'nivelExperiencia': nivelExperiencia,
      'peso': peso,
      'altura': altura,
      'objetivo': objetivo,
    };
  }

  static Usuario fromFirestore(Map<String, dynamic> data, String uid) {
    return Usuario(
      uid: uid,
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      nivelExperiencia: data['nivelExperiencia'] ?? '',
      peso: (data['peso'] ?? 0.0).toDouble(),
      altura: (data['altura'] ?? 0.0).toDouble(),
      objetivo: data['objetivo'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Usuario{uid: $uid, nombre: $nombre, email: $email, nivelExperiencia: $nivelExperiencia, peso: $peso, altura: $altura, objetivo: $objetivo}';
  }
}
