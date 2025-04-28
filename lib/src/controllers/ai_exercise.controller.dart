import 'dart:ui';
import 'package:get/get.dart';
import '../services/ai_recommendation_service.dart';
import '../services/workoutIA.services.dart';
import 'user.controller.dart';

class WorkoutRoutineController extends GetxController {
  // Variables observables
  RxBool isLoading = false.obs;
  RxBool hasWorkout = false.obs;
  Rx<Map<String, dynamic>> workoutData = Rx<Map<String, dynamic>>({});

  // Lista de rutinas guardadas
  RxList<Map<String, dynamic>> savedWorkouts = <Map<String, dynamic>>[].obs;

  // Variables para la configuración
  RxString selectedLevel = 'Intermedio'.obs;
  RxString selectedGoal = 'Hipertrofia'.obs;
  RxInt selectedDaysPerWeek = 4.obs;
  RxString selectedMuscleGroup = 'Todos'.obs;
  RxString additionalDetails = ''.obs;

  // Variable para el día seleccionado actualmente
  RxInt selectedDayIndex = 0.obs;

  // Instancia del servicio de base de datos
  final DatabaseService _databaseService = DatabaseService();

  // Controlador de autenticación
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    // Cargar rutinas guardadas al inicializar
    loadSavedWorkouts();
  }

  // Método para generar una rutina de entrenamiento
  Future<void> generateWorkout({
    String? level,
    String? goal,
    int? daysPerWeek,
    String? muscleGroup,
    String? details,
    bool autoSave =
        true, // Nuevo parámetro para controlar el guardado automático
  }) async {
    try {
      // Actualizar valores si se proporcionan
      if (level != null) selectedLevel.value = level;
      if (goal != null) selectedGoal.value = goal;
      if (daysPerWeek != null) selectedDaysPerWeek.value = daysPerWeek;
      if (muscleGroup != null) selectedMuscleGroup.value = muscleGroup;
      if (details != null) additionalDetails.value = details;

      // Indicar que estamos cargando
      isLoading.value = true;
      hasWorkout.value = false;

      // Llamar al servicio de IA
      final workout = await SimpleAIService.generateWorkoutRoutine(
        level: selectedLevel.value,
        goal: selectedGoal.value,
        daysPerWeek: selectedDaysPerWeek.value,
        focusMuscleGroup: selectedMuscleGroup.value == 'Todos'
            ? null
            : selectedMuscleGroup.value,
        additionalDetails:
            additionalDetails.value.isEmpty ? null : additionalDetails.value,
      );

      // Añadir timestamp a la rutina generada
      workout['createdAt'] = DateTime.now().toIso8601String();
      workout['updatedAt'] = DateTime.now().toIso8601String();

      // Asignar un ID único si no tiene
      if (!workout.containsKey('id')) {
        workout['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      }

      // Guardar los datos de la rutina
      workoutData.value = workout;

      // Resetear el día seleccionado
      selectedDayIndex.value = 0;

      // Actualizar estado
      isLoading.value = false;
      hasWorkout.value = true;

      // Guardar automáticamente si se solicita
      if (autoSave) {
        await saveWorkout(showMessage: false);
      }
    } catch (e) {
      // Manejar error
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'No se pudo generar la rutina: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  // Método actualizado para guardar la rutina en la base de datos con opción silenciosa
  Future<bool> saveWorkout({bool showMessage = true}) async {
    if (!hasWorkout.value) return false;

    try {
      isLoading.value = true;

      // Obtener el ID del usuario actual
      final String? userId = _authController.userModel.value?.uid;

      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      // Preparar los datos para guardar
      final Map<String, dynamic> workoutToSave =
          Map<String, dynamic>.from(workoutData.value);

      // Añadir metadatos si no existen
      workoutToSave['userId'] = userId;

      if (!workoutToSave.containsKey('createdAt')) {
        workoutToSave['createdAt'] = DateTime.now().toIso8601String();
      }

      workoutToSave['updatedAt'] = DateTime.now().toIso8601String();

      // Asegurarse de que tiene un ID único
      if (!workoutToSave.containsKey('id')) {
        workoutToSave['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      }

      // Verificar que tenga nombre
      if (!workoutToSave.containsKey('routineName') ||
          workoutToSave['routineName'] == null) {
        workoutToSave['routineName'] = "Rutina personalizada";
      }

      // Guardar en la base de datos
      await _databaseService.saveWorkout(workoutToSave);

      // Actualizar workoutData con el ID asignado (importante para referencias futuras)
      workoutData.value = workoutToSave;

      // Actualizar la lista de rutinas guardadas
      await loadSavedWorkouts();

      isLoading.value = false;

      // Mostrar mensaje solo si se solicita
      if (showMessage) {
        Get.snackbar(
          'Rutina guardada',
          'Tu rutina ha sido guardada correctamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF),
        );
      }

      return true;
    } catch (e) {
      print('Error al guardar rutina: $e');
      isLoading.value = false;

      if (showMessage) {
        Get.snackbar(
          'Error',
          'No se pudo guardar la rutina: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFE57373),
          colorText: const Color(0xFFFFFFFF),
        );
      }

      return false;
    }
  }

  // Método para seleccionar un día específico
  void selectDay(int index) {
    if (hasWorkout.value) {
      final workoutDays = _getWorkoutDays();
      if (index >= 0 && index < workoutDays.length) {
        selectedDayIndex.value = index;
      }
    }
  }

  // Método para obtener la lista de días de entrenamiento
  List<Map<String, dynamic>> _getWorkoutDays() {
    if (!hasWorkout.value) return [];

    try {
      final List<dynamic> days =
          workoutData.value['workoutDays'] as List<dynamic>;
      return days.map((day) => day as Map<String, dynamic>).toList();
    } catch (e) {
      return [];
    }
  }

  // Método para obtener el día seleccionado actualmente
  Map<String, dynamic>? getSelectedDay() {
    if (!hasWorkout.value) return null;

    final days = _getWorkoutDays();
    if (selectedDayIndex.value >= 0 && selectedDayIndex.value < days.length) {
      return days[selectedDayIndex.value];
    }

    return null;
  }

  // Método para obtener todos los días de entrenamiento
  List<Map<String, dynamic>> getAllWorkoutDays() {
    return _getWorkoutDays();
  }

  // Método para cargar rutinas guardadas desde la base de datos
  Future<void> loadSavedWorkouts() async {
    try {
      // Obtener el ID del usuario actual
      final String? userId = _authController.userModel.value?.uid;

      if (userId == null) {
        // Si no hay usuario logueado, limpiar la lista
        savedWorkouts.clear();
        return;
      }

      // Obtener rutinas de la base de datos
      final List<Map<String, dynamic>> workouts =
          await _databaseService.getWorkoutsByUserId(userId);

      // Actualizar la lista observable
      savedWorkouts.value = workouts;
    } catch (e) {
      // No mostrar error al usuario ya que puede ser llamado en segundo plano
    }
  }

  // Método para cargar una rutina guardada
  void loadSavedWorkout(Map<String, dynamic> workout) {
    try {
      // Hacer una copia para evitar modificaciones directas
      workoutData.value = Map<String, dynamic>.from(workout);
      hasWorkout.value = true;
      selectedDayIndex.value = 0;
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cargar la rutina',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  // Método para eliminar una rutina guardada
  Future<void> deleteWorkout(String workoutId) async {
    try {
      isLoading.value = true;

      // Eliminar de la base de datos
      await _databaseService.deleteWorkout(workoutId);

      // Actualizar la lista local
      savedWorkouts.removeWhere((workout) => workout['id'] == workoutId);

      isLoading.value = false;

      Get.snackbar(
        'Rutina eliminada',
        'La rutina ha sido eliminada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF9E9E9E),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'No se pudo eliminar la rutina: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  // Método para actualizar una rutina guardada
  Future<void> updateWorkout(Map<String, dynamic> updatedWorkout) async {
    try {
      isLoading.value = true;

      // Asegurarse de actualizar la fecha
      updatedWorkout['updatedAt'] = DateTime.now().toIso8601String();

      // Actualizar en la base de datos
      await _databaseService.updateWorkout(updatedWorkout);

      // Actualizar la lista local
      final index =
          savedWorkouts.indexWhere((w) => w['id'] == updatedWorkout['id']);
      if (index >= 0) {
        savedWorkouts[index] = updatedWorkout;
      }

      isLoading.value = false;

      Get.snackbar(
        'Rutina actualizada',
        'Tu rutina ha sido actualizada correctamente',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF2196F3),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'No se pudo actualizar la rutina: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE57373),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  // Método para compartir la rutina
  void shareWorkout() {
    if (hasWorkout.value) {
      // Implementación para compartir la rutina
      Get.snackbar(
        'Compartir',
        'Función para compartir rutina próximamente disponible',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Método para limpiar la rutina actual
  void clearWorkout() {
    hasWorkout.value = false;
    workoutData.value = {};
    selectedDayIndex.value = 0;
  }

  // Método para obtener la información general de la rutina
  Map<String, String> getWorkoutOverview() {
    if (!hasWorkout.value) return {};

    return {
      "nombre":
          workoutData.value['routineName'] as String? ?? "Rutina personalizada",
      "descripcion": workoutData.value['description'] as String? ?? "",
      "nivel": workoutData.value['level'] as String? ?? selectedLevel.value,
      "objetivo": workoutData.value['goal'] as String? ?? selectedGoal.value,
      "diasPorSemana": (workoutData.value['daysPerWeek']?.toString() ??
              selectedDaysPerWeek.value.toString()) +
          " días",
    };
  }

  // Método para obtener consejos nutricionales
  String getNutritionTips() {
    if (!hasWorkout.value) return "";
    return workoutData.value['nutritionTips'] as String? ??
        "Mantén una dieta equilibrada con suficiente proteína para recuperación muscular.";
  }

  // Método para obtener consejos para días de descanso
  String getRestDayTips() {
    if (!hasWorkout.value) return "";
    return workoutData.value['restDayTips'] as String? ??
        "Realiza actividades de baja intensidad como caminar o yoga en tus días de descanso.";
  }
}
