import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/ai_recommendation_service.dart';
import '../services/workoutIA.services.dart';
import 'user.controller.dart';

class WorkoutRoutineController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasWorkout = false.obs;
  Rx<Map<String, dynamic>> workoutData = Rx<Map<String, dynamic>>({});

  RxList<Map<String, dynamic>> savedWorkouts = <Map<String, dynamic>>[].obs;

  RxString selectedLevel = 'Intermedio'.obs;
  RxString selectedGoal = 'Hipertrofia'.obs;
  RxInt selectedDaysPerWeek = 4.obs;
  RxString selectedMuscleGroup = 'Todos'.obs;
  RxString additionalDetails = ''.obs;

  RxInt selectedDayIndex = 0.obs;

  final DatabaseService _databaseService = DatabaseService();

  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadSavedWorkouts();
  }

  Future<void> generateWorkout({
    String? level,
    String? goal,
    int? daysPerWeek,
    String? muscleGroup,
    String? details,
    bool autoSave = true,
  }) async {
    try {
      if (level != null) selectedLevel.value = level;
      if (goal != null) selectedGoal.value = goal;
      if (daysPerWeek != null) selectedDaysPerWeek.value = daysPerWeek;
      if (muscleGroup != null) selectedMuscleGroup.value = muscleGroup;
      if (details != null) additionalDetails.value = details;

      isLoading.value = true;
      hasWorkout.value = false;

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

      workout['createdAt'] = DateTime.now().toIso8601String();
      workout['updatedAt'] = DateTime.now().toIso8601String();

      if (!workout.containsKey('id')) {
        workout['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      }

      workoutData.value = workout;
      selectedDayIndex.value = 0;
      isLoading.value = false;
      hasWorkout.value = true;
      if (autoSave) {
        await saveWorkout(showMessage: false);
      }
    } catch (e) {
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

  Future<bool> saveWorkout({bool showMessage = true}) async {
    if (!hasWorkout.value) return false;

    try {
      isLoading.value = true;

      final String? userId = _authController.userModel.value?.uid;

      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      final Map<String, dynamic> workoutToSave =
          Map<String, dynamic>.from(workoutData.value);

      workoutToSave['userId'] = userId;

      if (!workoutToSave.containsKey('createdAt')) {
        workoutToSave['createdAt'] = DateTime.now().toIso8601String();
      }

      workoutToSave['updatedAt'] = DateTime.now().toIso8601String();

      if (!workoutToSave.containsKey('id')) {
        workoutToSave['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      }

      if (!workoutToSave.containsKey('routineName') ||
          workoutToSave['routineName'] == null) {
        workoutToSave['routineName'] = "Rutina personalizada";
      }

      await _databaseService.saveWorkout(workoutToSave);

      workoutData.value = workoutToSave;

      await loadSavedWorkouts();

      isLoading.value = false;

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
      debugPrint('Error al guardar rutina: $e');
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

  void selectDay(int index) {
    if (hasWorkout.value) {
      final workoutDays = _getWorkoutDays();
      if (index >= 0 && index < workoutDays.length) {
        selectedDayIndex.value = index;
      }
    }
  }

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

  Map<String, dynamic>? getSelectedDay() {
    if (!hasWorkout.value) return null;

    final days = _getWorkoutDays();
    if (selectedDayIndex.value >= 0 && selectedDayIndex.value < days.length) {
      return days[selectedDayIndex.value];
    }

    return null;
  }

  List<Map<String, dynamic>> getAllWorkoutDays() {
    return _getWorkoutDays();
  }

  Future<void> loadSavedWorkouts() async {
    try {
      final String? userId = _authController.userModel.value?.uid;

      if (userId == null) {
        savedWorkouts.clear();
        return;
      }

      final List<Map<String, dynamic>> workouts =
          await _databaseService.getWorkoutsByUserId(userId);

      savedWorkouts.value = workouts;
      _sortSavedWorkoutsByDate();
    } catch (e) {
      // No mostrar error al usuario ya que puede ser llamado en segundo plano
    }
  }

  // Método para cargar una rutina guardada
  void loadSavedWorkout(Map<String, dynamic> workout) {
    try {
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

  void _sortSavedWorkoutsByDate() {
    if (savedWorkouts.isNotEmpty) {
      savedWorkouts.sort((a, b) {
        String dateA = a['createdAt'] ?? '';
        String dateB = b['createdAt'] ?? '';

        if (dateA.isEmpty) return 1;
        if (dateB.isEmpty) return -1;

        try {
          return DateTime.parse(dateB).compareTo(DateTime.parse(dateA));
        } catch (e) {
          return 0;
        }
      });
    }
  }

  Future<void> deleteWorkout(String workoutId) async {
    try {
      isLoading.value = true;
      await _databaseService.deleteWorkout(workoutId);

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

  Future<void> updateWorkout(Map<String, dynamic> updatedWorkout) async {
    try {
      isLoading.value = true;
      updatedWorkout['updatedAt'] = DateTime.now().toIso8601String();

      await _databaseService.updateWorkout(updatedWorkout);
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

  void shareWorkout() {
    if (hasWorkout.value) {
      Get.snackbar(
        'Compartir',
        'Función para compartir rutina próximamente disponible',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearWorkout() {
    hasWorkout.value = false;
    workoutData.value = {};
    selectedDayIndex.value = 0;
  }

  Map<String, String> getWorkoutOverview() {
    if (!hasWorkout.value) return {};

    return {
      "nombre":
          workoutData.value['routineName'] as String? ?? "Rutina personalizada",
      "descripcion": workoutData.value['description'] as String? ?? "",
      "nivel": workoutData.value['level'] as String? ?? selectedLevel.value,
      "objetivo": workoutData.value['goal'] as String? ?? selectedGoal.value,
      "diasPorSemana":
          "${workoutData.value['daysPerWeek']?.toString() ?? selectedDaysPerWeek.value.toString()} días",
    };
  }

  String getNutritionTips() {
    if (!hasWorkout.value) return "";
    return workoutData.value['nutritionTips'] as String? ??
        "Mantén una dieta equilibrada con suficiente proteína para recuperación muscular.";
  }

  String getRestDayTips() {
    if (!hasWorkout.value) return "";
    return workoutData.value['restDayTips'] as String? ??
        "Realiza actividades de baja intensidad como caminar o yoga en tus días de descanso.";
  }
}
