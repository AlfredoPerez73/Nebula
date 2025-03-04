class Usuario {
  String idUsuario;
  String nombre;
  String email;
  String nivelExperiencia;
  double peso;
  double altura;
  String objetivo;
  List<String> historialEjercicios;
  bool suscripcion;

  Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.email,
    required this.nivelExperiencia,
    required this.peso,
    required this.altura,
    required this.objetivo,
    required this.historialEjercicios,
    required this.suscripcion,
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
        "historialEjercicios": historialEjercicios,
        "suscripcion": suscripcion,
      };

  // Crear usuario desde JSON de Firebase
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        idUsuario: json["idUsuario"],
        nombre: json["nombre"],
        email: json["email"],
        nivelExperiencia: json["nivelExperiencia"],
        peso: json["peso"].toDouble(),
        altura: json["altura"].toDouble(),
        objetivo: json["objetivo"],
        historialEjercicios: List<String>.from(json["historialEjercicios"]),
        suscripcion: json["suscripcion"],
      );
}
