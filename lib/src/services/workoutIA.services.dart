import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  // Referencia a la colección de rutinas
  final CollectionReference workoutsCollection =
      FirebaseFirestore.instance.collection('workouts');

  // Método para guardar una rutina en Firestore
  Future<void> saveWorkout(Map<String, dynamic> workout) async {
    try {
      // Verificar si existe el ID
      final String workoutId = workout['id'] as String;

      // Guardar en Firestore
      await workoutsCollection.doc(workoutId).set(workout);
    } catch (e) {
      debugPrint('Error al guardar rutina: $e');
      throw Exception('Error al guardar rutina: $e');
    }
  }

  // Método para obtener rutinas de un usuario específico
  Future<List<Map<String, dynamic>>> getWorkoutsByUserId(String userId) async {
    try {
      // Consultar rutinas donde userId coincida
      final QuerySnapshot querySnapshot =
          await workoutsCollection.where('userId', isEqualTo: userId).get();

      // Convertir QuerySnapshot a List<Map<String, dynamic>>
      return querySnapshot.docs.map((doc) {
        // Convertir DocumentSnapshot a Map
        final data = doc.data() as Map<String, dynamic>;
        // Asegurarse de que el ID esté incluido
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Error al obtener rutinas: $e');
      throw Exception('Error al obtener rutinas: $e');
    }
  }

  // Método para obtener una rutina específica por ID
  Future<Map<String, dynamic>?> getWorkoutById(String workoutId) async {
    try {
      final DocumentSnapshot docSnapshot =
          await workoutsCollection.doc(workoutId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        // Asegurarse de que el ID esté incluido
        data['id'] = docSnapshot.id;
        return data;
      }

      return null;
    } catch (e) {
      debugPrint('Error al obtener rutina: $e');
      throw Exception('Error al obtener rutina: $e');
    }
  }

  // Método para actualizar una rutina existente
  Future<void> updateWorkout(Map<String, dynamic> workout) async {
    try {
      final String workoutId = workout['id'] as String;

      // Actualizar en Firestore
      await workoutsCollection.doc(workoutId).update(workout);
    } catch (e) {
      debugPrint('Error al actualizar rutina: $e');
      throw Exception('Error al actualizar rutina: $e');
    }
  }

  // Método para eliminar una rutina
  Future<void> deleteWorkout(String workoutId) async {
    try {
      await workoutsCollection.doc(workoutId).delete();
    } catch (e) {
      debugPrint('Error al eliminar rutina: $e');
      throw Exception('Error al eliminar rutina: $e');
    }
  }

  // Método para obtener las rutinas más populares
  Future<List<Map<String, dynamic>>> getPopularWorkouts(
      {int limit = 10}) async {
    try {
      // Esta consulta asume que tienes un campo 'saveCount' o similar
      // que rastrea popularidad. Puedes adaptarlo según necesites.
      final QuerySnapshot querySnapshot = await workoutsCollection
          .orderBy('saveCount', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Error al obtener rutinas populares: $e');
      throw Exception('Error al obtener rutinas populares: $e');
    }
  }

  // Método para incrementar el contador de guardados (para rutinas compartidas)
  Future<void> incrementSaveCount(String workoutId) async {
    try {
      await workoutsCollection
          .doc(workoutId)
          .update({'saveCount': FieldValue.increment(1)});
    } catch (e) {
      debugPrint('Error al incrementar contador: $e');
      throw Exception('Error al incrementar contador: $e');
    }
  }

  // Método para guardar una rutina compartida por otro usuario
  Future<void> saveSharedWorkout(
      String originalWorkoutId, String userId) async {
    try {
      // Primero, obtener la rutina original
      final Map<String, dynamic>? originalWorkout =
          await getWorkoutById(originalWorkoutId);

      if (originalWorkout == null) {
        throw Exception('Rutina no encontrada');
      }

      // Crear una copia de la rutina para el nuevo usuario
      final Map<String, dynamic> newWorkout =
          Map<String, dynamic>.from(originalWorkout);

      // Actualizar metadatos
      newWorkout['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      newWorkout['userId'] = userId;
      newWorkout['originalWorkoutId'] = originalWorkoutId;
      newWorkout['createdAt'] = DateTime.now().toIso8601String();
      newWorkout['updatedAt'] = DateTime.now().toIso8601String();
      newWorkout['sharedFrom'] = originalWorkout['userId'];

      // Guardar la copia
      await saveWorkout(newWorkout);

      // Incrementar contador en la original
      await incrementSaveCount(originalWorkoutId);
    } catch (e) {
      debugPrint('Error al guardar rutina compartida: $e');
      throw Exception('Error al guardar rutina compartida: $e');
    }
  }

  // Método para obtener categorías disponibles (niveles)
  Future<List<String>> getAvailableLevels() async {
    try {
      // Obtener rutinas y extraer niveles únicos
      final QuerySnapshot querySnapshot = await workoutsCollection.get();

      final Set<String> levels = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('level') && data['level'] != null) {
          levels.add(data['level'] as String);
        }
      }

      return levels.toList();
    } catch (e) {
      debugPrint('Error al obtener niveles: $e');
      return ['Principiante', 'Intermedio', 'Avanzado']; // Valores por defecto
    }
  }

  // Método para obtener objetivos disponibles
  Future<List<String>> getAvailableGoals() async {
    try {
      // Obtener rutinas y extraer objetivos únicos
      final QuerySnapshot querySnapshot = await workoutsCollection.get();

      final Set<String> goals = {};

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('goal') && data['goal'] != null) {
          goals.add(data['goal'] as String);
        }
      }

      return goals.toList();
    } catch (e) {
      debugPrint('Error al obtener objetivos: $e');
      return [
        'Hipertrofia',
        'Fuerza',
        'Resistencia',
        'Pérdida de peso'
      ]; // Valores por defecto
    }
  }
}
