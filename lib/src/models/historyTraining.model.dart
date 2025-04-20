import 'package:nebula/src/models/historyExercises.model.dart';

class HistoryEntrenamiento {
  final String id;
  final String usuarioId;
  final String nombre;
  final List<HistoryEjercicio> _ejercicios;

  // Getter para acceder a una copia inmutable de la lista de ejercicios
  List<HistoryEjercicio> get ejercicios => List.unmodifiable(_ejercicios);

  HistoryEntrenamiento({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    List<HistoryEjercicio>? ejercicios,
  }) : _ejercicios = ejercicios ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'nombre': nombre,
      'ejercicios': _ejercicios.map((e) => e.toMap()).toList(),
    };
  }

  // Versión simplificada para Firebase (sin la lista de ejercicios)
  Map<String, dynamic> toFirebaseMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'nombre': nombre,
    };
  }

  static HistoryEntrenamiento fromFirestore(
      Map<String, dynamic> data, String id,
      {List<HistoryEjercicio>? ejercicios}) {
    return HistoryEntrenamiento(
      id: id,
      usuarioId: data['usuarioId'] ?? '',
      nombre: data['nombre'] ?? '',
      ejercicios: ejercicios ?? [],
    );
  }
}
