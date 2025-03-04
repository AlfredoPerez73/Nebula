class Ejercicio {
  String idEjercicio;
  String nombre;
  String descripcion;
  String videoUrl;
  String grupoMuscular;
  int repeticiones;
  int descanso; // En segundos

  Ejercicio({
    required this.idEjercicio,
    required this.nombre,
    required this.descripcion,
    required this.videoUrl,
    required this.grupoMuscular,
    required this.repeticiones,
    required this.descanso,
  });

  Map<String, dynamic> toJson() => {
        "idEjercicio": idEjercicio,
        "nombre": nombre,
        "descripcion": descripcion,
        "videoUrl": videoUrl,
        "grupoMuscular": grupoMuscular,
        "repeticiones": repeticiones,
        "descanso": descanso,
      };

  factory Ejercicio.fromJson(Map<String, dynamic> json) => Ejercicio(
        idEjercicio: json["idEjercicio"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        videoUrl: json["videoUrl"],
        grupoMuscular: json["grupoMuscular"],
        repeticiones: json["repeticiones"],
        descanso: json["descanso"],
      );
}
