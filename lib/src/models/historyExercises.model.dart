class HistoryEjercicio {
  final String id;
  final String nombre;
  final String dia;
  final int series;
  final String repeticiones;

  HistoryEjercicio({
    required this.id,
    required this.nombre,
    required this.dia,
    required this.series,
    required this.repeticiones,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'dia': dia,
      'series': series,
      'repeticiones': repeticiones,
    };
  }

  static HistoryEjercicio fromFirestore(Map<String, dynamic> data, String id) {
    return HistoryEjercicio(
      id: id,
      nombre: data['nombre'] ?? '',
      dia: data['dia'] ?? '',
      series: data['series'] ?? 0,
      repeticiones: data['repeticiones'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Ejercicio{id: $id, nombre: $nombre, dia: $dia, series: $series, repeticiones: $repeticiones}';
  }
}
