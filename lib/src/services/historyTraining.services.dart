import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nebula/src/models/historyTraining.model.dart';
import 'package:nebula/src/models/historyExercises.model.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Uuid _uuid = Uuid();

  // Colecciones
  final String _entrenamientosCollection = 'historytraining';

  // Obtener el usuario actual
  String? get currentUserId => _auth.currentUser?.uid;

  // Crear un nuevo entrenamiento (sin ejercicios inicialmente)
  Future<String> crearEntrenamiento(String nombre) async {
    if (currentUserId == null) {
      throw Exception('Usuario no autenticado');
    }

    String id = _uuid.v4();
    final nuevoEntrenamiento = HistoryEntrenamiento(
      id: id,
      usuarioId: currentUserId!,
      nombre: nombre,
    );

    // Guardar el entrenamiento básico
    await _firestore
        .collection(_entrenamientosCollection)
        .doc(id)
        .set(nuevoEntrenamiento.toFirebaseMap());

    return id;
  }

  // Agregar un ejercicio a un entrenamiento existente
  Future<void> agregarEjercicioAEntrenamiento(
      String entrenamientoId, HistoryEjercicio ejercicio) async {
    if (currentUserId == null) {
      throw Exception('Usuario no autenticado');
    }

    // Generar ID para el ejercicio si no tiene uno
    String ejercicioId = ejercicio.id.isEmpty ? _uuid.v4() : ejercicio.id;

    // Crear copia del ejercicio con ID garantizado
    final ejercicioConId = HistoryEjercicio(
      id: ejercicioId,
      nombre: ejercicio.nombre,
      dia: ejercicio.dia,
      series: ejercicio.series,
      repeticiones: ejercicio.repeticiones,
    );

    // Guardar el ejercicio en la subcolección del entrenamiento
    await _firestore
        .collection(_entrenamientosCollection)
        .doc(entrenamientoId)
        .collection('historyexercise')
        .doc(ejercicioId)
        .set(ejercicioConId.toMap());
  }

  // Eliminar un entrenamiento completo
  Future<void> eliminarEntrenamiento(String entrenamientoId) async {
    if (currentUserId == null) {
      throw Exception('Usuario no autenticado');
    }

    // Eliminar el documento principal del entrenamiento
    await _firestore
        .collection(_entrenamientosCollection)
        .doc(entrenamientoId)
        .delete();
  }

  // Obtener un entrenamiento con sus ejercicios
  Future<HistoryEntrenamiento?> obtenerEntrenamiento(
      String entrenamientoId) async {
    if (currentUserId == null) {
      throw Exception('Usuario no autenticado');
    }

    // Obtener el documento del entrenamiento
    final docSnapshot =
        await _firestore.collection('training').doc(entrenamientoId).get();

    if (!docSnapshot.exists) {
      return null;
    }

    // Obtener los ejercicios asociados al entrenamiento
    final ejerciciosSnapshot = await _firestore
        .collection(_entrenamientosCollection)
        .doc(entrenamientoId)
        .collection('historyexercise')
        .get();

    List<HistoryEjercicio> ejercicios = ejerciciosSnapshot.docs
        .map((ejercicioDoc) => HistoryEjercicio.fromFirestore(
            ejercicioDoc.data(), ejercicioDoc.id))
        .toList();

    // Crear el objeto Entrenamiento con sus ejercicios
    return HistoryEntrenamiento.fromFirestore(
        docSnapshot.data()!, docSnapshot.id,
        ejercicios: ejercicios);
  }

  // Obtener todos los entrenamientos del usuario actual
  Future<List<HistoryEntrenamiento>> obtenerEntrenamientosUsuario() async {
    if (currentUserId == null) {
      throw Exception('Usuario no autenticado');
    }

    final snapshot = await _firestore
        .collection('historytraining')
        .where('usuarioId', isEqualTo: currentUserId)
        .get();

    List<HistoryEntrenamiento> entrenamientos = [];

    for (var doc in snapshot.docs) {
      // Obtener los ejercicios asociados al entrenamiento
      final ejerciciosSnapshot = await _firestore
          .collection('historytraining')
          .doc(doc.id)
          .collection('historyexercise')
          .get();

      List<HistoryEjercicio> ejercicios = ejerciciosSnapshot.docs
          .map((ejercicioDoc) => HistoryEjercicio.fromFirestore(
              ejercicioDoc.data(), ejercicioDoc.id))
          .toList();

      // Crear el objeto Entrenamiento con sus ejercicios
      entrenamientos.add(HistoryEntrenamiento.fromFirestore(doc.data(), doc.id,
          ejercicios: ejercicios));
    }
    return entrenamientos;
  }

  // Actualizar un ejercicio en un entrenamiento específico
  Future<void> actualizarEjercicioEnEntrenamiento(
      String entrenamientoId, HistoryEjercicio ejercicio) async {
    try {
      // Referencia al documento del ejercicio dentro del entrenamiento
      final DocumentReference ejercicioRef = FirebaseFirestore.instance
          .collection('historytraining')
          .doc(entrenamientoId)
          .collection('historyexercise')
          .doc(ejercicio.id);

      // Convertir el ejercicio a un mapa y actualizar en Firebase
      await ejercicioRef.update(ejercicio.toMap());
    } catch (e) {
      throw Exception('Error al actualizar ejercicio: ${e.toString()}');
    }
  }

  Future<void> guardarUltimoEntrenamientoSeleccionado(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ultimo_entrenamiento_id', id);
  }

// Add this method to retrieve the last selected training ID
  Future<String?> obtenerUltimoEntrenamientoSeleccionado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('ultimo_entrenamiento_id');
  }
}
