class Rutina {
  String idRutina;
  String idUsuario;
  String nombreRutina;
  String objetivoRutina;
  int duracion; // En minutos
  List<String> ejercicios; // Lista de IDs de ejercicios

  Rutina({
    required this.idRutina,
    required this.idUsuario,
    required this.nombreRutina,
    required this.objetivoRutina,
    required this.duracion,
    required this.ejercicios,
  });

  Map<String, dynamic> toJson() => {
        "idRutina": idRutina,
        "idUsuario": idUsuario,
        "nombreRutina": nombreRutina,
        "objetivoRutina": objetivoRutina,
        "duracion": duracion,
        "ejercicios": ejercicios,
      };

  factory Rutina.fromJson(Map<String, dynamic> json) => Rutina(
        idRutina: json["idRutina"],
        idUsuario: json["idUsuario"],
        nombreRutina: json["nombreRutina"],
        objetivoRutina: json["objetivoRutina"],
        duracion: json["duracion"],
        ejercicios: List<String>.from(json["ejercicios"]),
      );
}
