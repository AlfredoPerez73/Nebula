// lib/src/controllers/workout_routine_controller.dart

import 'dart:ui';

import 'package:get/get.dart';
import '../services/ai_recommendation_service.dart';

class WorkoutRoutineController extends GetxController {
  // Variables observables
  RxBool isLoading = false.obs;
  RxBool hasWorkout = false.obs;
  Rx<Map<String, dynamic>> workoutData = Rx<Map<String, dynamic>>({});
  
  // Variables para la configuración
  RxString selectedLevel = 'Intermedio'.obs;
  RxString selectedGoal = 'Hipertrofia'.obs;
  RxInt selectedDaysPerWeek = 4.obs;
  RxString selectedMuscleGroup = 'Todos'.obs;
  RxString additionalDetails = ''.obs;
  
  // Variable para el día seleccionado actualmente
  RxInt selectedDayIndex = 0.obs;
  
  // Método para generar una rutina de entrenamiento
  Future<void> generateWorkout({
    String? level,
    String? goal,
    int? daysPerWeek,
    String? muscleGroup,
    String? details,
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
        focusMuscleGroup: selectedMuscleGroup.value == 'Todos' ? null : selectedMuscleGroup.value,
        additionalDetails: additionalDetails.value.isEmpty ? null : additionalDetails.value,
      );
      
      // Guardar los datos de la rutina
      workoutData.value = workout;
      
      // Resetear el día seleccionado
      selectedDayIndex.value = 0;
      
      // Actualizar estado
      isLoading.value = false;
      hasWorkout.value = true;
      
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
      final List<dynamic> days = workoutData.value['workoutDays'] as List<dynamic>;
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
  
  // Método para guardar la rutina (implementación básica)
  Future<void> saveWorkout() async {
    if (hasWorkout.value) {
      // Aquí implementarías la lógica para guardar la rutina,
      // por ejemplo, en Firebase o almacenamiento local
      Get.snackbar(
        'Rutina guardada',
        'Tu rutina ha sido guardada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Método para compartir la rutina (implementación básica)
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
      "nombre": workoutData.value['routineName'] as String? ?? "Rutina personalizada",
      "descripcion": workoutData.value['description'] as String? ?? "",
      "nivel": workoutData.value['level'] as String? ?? selectedLevel.value,
      "objetivo": workoutData.value['goal'] as String? ?? selectedGoal.value,
      "diasPorSemana": (workoutData.value['daysPerWeek']?.toString() ?? selectedDaysPerWeek.value.toString()) + " días",
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