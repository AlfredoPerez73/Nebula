class Usuario {
  String idUsuario;
  String nombre;
  String email;
  String nivelExperiencia;
  double peso;
  double altura;
  String objetivo;

  Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.email,
    required this.nivelExperiencia,
    required this.peso,
    required this.altura,
    required this.objetivo,
  });

  // Convertir a JSON para Firebase
  Map<String, dynamic> toJson() => {
        "idUsuario": idUsuario,
        "nombre": nombre,
        "email": email,
        "nivelExperiencia": nivelExperiencia,
        "peso": peso,
        "altura": altura,
        "objetivo": objetivo,
      };

  // Crear usuario desde JSON de Firebase
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        idUsuario: json["idUsuario"],
        nombre: json["nombre"],
        email: json["email"],
        nivelExperiencia: json["nivelExperiencia"],
        peso: (json["peso"] ?? 0).toDouble(), // Manejo de valores nulos
        altura: (json["altura"] ?? 0).toDouble(),
        objetivo: json["objetivo"] ?? "",
      );
}
