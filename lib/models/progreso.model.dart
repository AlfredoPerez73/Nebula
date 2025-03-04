class Progreso {
  String idProgreso;
  String idUsuario;
  DateTime fecha;
  double pesoActual;
  int repeticionesCompletadas;
  double caloriasQuemadas;

  Progreso({
    required this.idProgreso,
    required this.idUsuario,
    required this.fecha,
    required this.pesoActual,
    required this.repeticionesCompletadas,
    required this.caloriasQuemadas,
  });

  Map<String, dynamic> toJson() => {
        "idProgreso": idProgreso,
        "idUsuario": idUsuario,
        "fecha": fecha.toIso8601String(),
        "pesoActual": pesoActual,
        "repeticionesCompletadas": repeticionesCompletadas,
        "caloriasQuemadas": caloriasQuemadas,
      };

  factory Progreso.fromJson(Map<String, dynamic> json) => Progreso(
        idProgreso: json["idProgreso"],
        idUsuario: json["idUsuario"],
        fecha: DateTime.parse(json["fecha"]),
        pesoActual: json["pesoActual"].toDouble(),
        repeticionesCompletadas: json["repeticionesCompletadas"],
        caloriasQuemadas: json["caloriasQuemadas"].toDouble(),
      );
}
