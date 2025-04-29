import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amicons/amicons.dart';
import 'package:nebula/src/controllers/ai_exercise.controller.dart';
import 'package:nebula/src/widgets/workout/workout_display_widget.dart';

class AllWorkoutsScreen extends StatelessWidget {
  final WorkoutRoutineController workoutController;

  const AllWorkoutsScreen({
    Key? key,
    required this.workoutController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 0,
        title: const Text(
          "Todas las Rutinas",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ECE1),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFF7ECE1)),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            if (workoutController.savedWorkouts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Amicons.lucide_dumbbell,
                      size: 64,
                      color: const Color(0xFF9067C6).withOpacity(0.7),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "No hay rutinas guardadas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF7ECE1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Genera tu primera rutina personalizada con IA",
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xFFF7ECE1).withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: workoutController.savedWorkouts.length,
              itemBuilder: (context, index) {
                final workout = workoutController.savedWorkouts[index];
                return _buildWorkoutItem(workout);
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(Map<String, dynamic> workout) {
    // Extraer información relevante del workout
    final String title = workout['routineName'] ?? "Rutina Personalizada";
    final String level = workout['level'] ?? "Personalizado";
    final dynamic daysValue = workout['daysPerWeek'];
    final int days = daysValue is int ? daysValue : 0;
    final String goal = workout['goal'] ?? "General";
    final String date = workout['createdAt'] ?? "Reciente";

    // Extraer los días de entrenamiento (solo sus nombres)
    List<String> workoutDayNames = [];
    if (workout.containsKey('workoutDays') && workout['workoutDays'] is List) {
      final List<dynamic> rawDays = workout['workoutDays'] as List<dynamic>;
      for (var day in rawDays) {
        if (day is Map<String, dynamic> && day.containsKey('day')) {
          String dayName = day['day']?.toString() ?? "";
          if (dayName.isNotEmpty) {
            workoutDayNames.add(dayName);
          }
        }
      }
    }

    // Calcular opacidad basada en la antigüedad (más reciente = más opaco)
    double opacity = 0.8;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF8D86C9).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8D86C9).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Encabezado de la rutina
          InkWell(
            onTap: () {
              // Cargar la rutina guardada y mostrarla completa
              workoutController.loadSavedWorkout(workout);
              _showWorkoutDisplay();
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF8D86C9).withOpacity(opacity),
                          const Color(0xFF9067C6).withOpacity(opacity),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForWorkoutGoal(goal),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFF7ECE1),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$days días/semana • ${_capitalizeFirstLetter(level)} • ${_capitalizeFirstLetter(goal)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFFF7ECE1).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatDate(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFFF7ECE1).withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: const Color(0xFFF7ECE1).withOpacity(0.6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Vista simplificada con solo los días de entrenamiento
          if (workoutDayNames.isNotEmpty) ...[
            const Divider(
              color: Color(0xFF8D86C9),
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: workoutDayNames.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final String dayName = entry.value;

                  return GestureDetector(
                    onTap: () {
                      workoutController.loadSavedWorkout(workout);
                      workoutController.selectDay(index);
                      _showWorkoutDisplay();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9067C6).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF9067C6).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        dayName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF7ECE1),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showWorkoutDisplay() {
    // Utilizar Get.to para navegar a la pantalla de rutina
    Get.to(
      () => Scaffold(
        body: Obx(() => WorkoutDisplayWidget(
              workoutData: workoutController.workoutData.value,
              onClose: () {
                // Limpiar la rutina al cerrar
                workoutController.clearWorkout();
                Get.back();
              },
            )),
      ),
      fullscreenDialog: true,
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Función auxiliar para obtener el ícono basado en el objetivo del entrenamiento
  IconData _getIconForWorkoutGoal(String goal) {
    switch (goal.toLowerCase()) {
      case 'fuerza':
        return Amicons.lucide_dumbbell;
      case 'hipertrofia':
        return Amicons.lucide_activity;
      case 'resistencia':
        return Amicons.lucide_timer;
      case 'baja de peso':
        return Amicons.lucide_flame;
      case 'cardio':
        return Amicons.lucide_heart_pulse;
      default:
        return Amicons.vuesax_clipboard_export;
    }
  }

  // Función auxiliar para capitalizar la primera letra
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Función auxiliar para formatear la fecha
  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return "Reciente";

    try {
      // Convertir la fecha ISO a un objeto DateTime
      final DateTime dateTime = DateTime.parse(dateStr);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return "Hoy";
      } else if (difference.inDays == 1) {
        return "Ayer";
      } else if (difference.inDays < 7) {
        return "Hace ${difference.inDays} días";
      } else if (difference.inDays < 30) {
        final int weeks = (difference.inDays / 7).floor();
        return "Hace $weeks ${weeks == 1 ? 'semana' : 'semanas'}";
      } else {
        // Formato de fecha básico para fechas más antiguas
        return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      }
    } catch (e) {
      print("Error al formatear fecha: $e");
      return dateStr;
    }
  }
}
