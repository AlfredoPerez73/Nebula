import 'package:nebula/src/models/exercises.model.dart';

class Entrenamiento {
  final String id;
  final String usuarioId;
  final String nombre;
  final List<Ejercicio> _ejercicios;

  // Getter para acceder a una copia inmutable de la lista de ejercicios
  List<Ejercicio> get ejercicios => List.unmodifiable(_ejercicios);

  Entrenamiento({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    List<Ejercicio>? ejercicios,
  }) : _ejercicios = ejercicios ?? [];

  // Método para añadir un ejercicio
  void agregarEjercicio(Ejercicio ejercicio) {
    _ejercicios.add(ejercicio);
  }

  // Método para eliminar un ejercicio por ID
  void eliminarEjercicio(String ejercicioId) {
    _ejercicios.removeWhere((e) => e.id == ejercicioId);
  }

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

  static Entrenamiento fromFirestore(Map<String, dynamic> data, String id,
      {List<Ejercicio>? ejercicios}) {
    return Entrenamiento(
      id: id,
      usuarioId: data['usuarioId'] ?? '',
      nombre: data['nombre'] ?? '',
      ejercicios: ejercicios ?? [],
    );
  }
}
