import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amicons/amicons.dart';
import 'package:nebula/src/controllers/ai_exercise.controller.dart';
import 'package:nebula/src/widgets/workout/all_workouts_screens.dart';
import '../../controllers/user.controller.dart';
import '../../widgets/workout/workout_display_widget.dart';
import '../../widgets/workout/workout_loading_dialog.dart';
import '../../widgets/workout/workout_selector_dialog.dart';

class Iaexcersispage extends StatefulWidget {
  const Iaexcersispage({super.key});

  @override
  State<Iaexcersispage> createState() => _IaexcersisPageState();
}

class _IaexcersisPageState extends State<Iaexcersispage> {
  final AuthController authController = Get.find<AuthController>();
  final WorkoutRoutineController workoutController =
      Get.put(WorkoutRoutineController());
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = "Todos";
  String selectedMuscleGroup = "Todos";

  // Lista de categorías de ejercicios
  final List<String> categories = [
    "Todos",
    "Principiante",
    "Intermedio",
    "Avanzado"
  ];

  // Lista de grupos musculares
  final List<String> muscleGroups = [
    "Todos",
    "Piernas",
    "Pecho",
    "Espalda",
    "Brazos",
    "Hombros",
    "Core"
  ];

  @override
  void initState() {
    super.initState();
    workoutController.loadSavedWorkouts();
    _sortWorkoutsByDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageHeader(),
                const SizedBox(height: 24),
                _buildAIRecommendationCard(),
                const SizedBox(height: 24),
                _buildQuickAccessSection(),
                const SizedBox(height: 24),
                _buildRecentWorkoutsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ENTRENAMIENTOS IA",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: Color(0xFFF7ECE1),
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
                  "Hola, ${authController.userModel.value?.nombre ?? 'atleta'}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFCAC4CE).withValues(alpha: 0.9),
                  ),
                )),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF8D86C9).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(12),
          child: const Icon(
            Amicons.lucide_brain_circuit,
            color: Color(0xFF9067C6),
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildAIRecommendationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8D86C9),
            Color(0xFF9067C6),
          ],
          stops: [0.2, 0.9],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9067C6).withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Amicons.lucide_brain,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Entrenamiento Personalizado",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF7ECE1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() {
                      String nivel =
                          authController.userModel.value?.nivelExperiencia ??
                              'principiante';
                      String objetivo =
                          authController.userModel.value?.objetivo ??
                              'mantenimiento';

                      return Text(
                        "Nivel: $nivel | Objetivo: $objetivo",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFF7ECE1).withValues(alpha: 0.8),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Una rutina adaptada específicamente a tu perfil, considerando tu experiencia, objetivos y disponibilidad. Se guarda automáticamente.",
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: Color(0xFFF7ECE1),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showWorkoutSelectorDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF9067C6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Amicons.lucide_sparkles, size: 18),
                      SizedBox(width: 10),
                      Text(
                        "CREAR RUTINA",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Filtros Rápidos",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ECE1),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickAccessCard(
                "Fuerza",
                Amicons.lucide_dumbbell,
                const Color(0xFF8D86C9),
              ),
              _buildQuickAccessCard(
                "Hipertrofia",
                Amicons.lucide_activity,
                const Color(0xFF9067C6),
              ),
              _buildQuickAccessCard(
                "Resistencia",
                Amicons.lucide_timer,
                const Color(0xFF8D86C9),
              ),
              _buildQuickAccessCard(
                "Cardio",
                Amicons.lucide_flame,
                const Color(0xFF9067C6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard(String title, IconData icon, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        color: color.withValues(alpha: 0.2),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: () {
            // Acción al seleccionar un filtro rápido
            final additionalDetails = "Enfoque en $title";
            _showWorkoutSelectorDialogWithPreset(
                title.toLowerCase(), additionalDetails);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF7ECE1).withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentWorkoutsSection() {
    return Obx(() {
      // Verificar si hay rutinas guardadas
      bool hasWorkouts = workoutController.savedWorkouts.isNotEmpty;
      bool hasMoreWorkouts = workoutController.savedWorkouts.length > 3;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Rutinas IA Guardadas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                ),
              ),
              if (hasMoreWorkouts)
                TextButton(
                  onPressed: () {
                    _showAllWorkouts();
                  },
                  child: Row(
                    children: [
                      Text(
                        "Ver todos",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9067C6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Color(0xFF9067C6),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          hasWorkouts
              ? Column(
                  children:
                      workoutController.savedWorkouts.take(3).map((workout) {
                    return _buildSavedWorkoutItem(workout);
                  }).toList(),
                )
              : _buildEmptyWorkoutState(),
        ],
      );
    });
  }

  void _showAllWorkouts() {
    // Añade esta línea para ordenar antes de mostrar todas las rutinas
    _sortWorkoutsByDate();

    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) =>
            AllWorkoutsScreen(workoutController: workoutController),
      ),
    )
        .then((value) {
      // Refrescar la lista de rutinas al regresar
      if (mounted) {
        workoutController.loadSavedWorkouts();
        _sortWorkoutsByDate(); // Añade esta línea
      }
    });
  }

  void _sortWorkoutsByDate() {
    if (workoutController.savedWorkouts.isNotEmpty) {
      workoutController.savedWorkouts.sort((a, b) {
        // Obtener las fechas de creación
        String dateA = a['createdAt'] ?? '';
        String dateB = b['createdAt'] ?? '';

        // Si alguna fecha está vacía, manejar el caso
        if (dateA.isEmpty) return 1; // a va después
        if (dateB.isEmpty) return -1; // b va después

        try {
          // Comparar fechas en orden descendente (más reciente primero)
          return DateTime.parse(dateB).compareTo(DateTime.parse(dateA));
        } catch (e) {
          debugPrint("Error al ordenar por fecha: $e");
          return 0;
        }
      });
    }
  }

  Widget _buildSavedWorkoutItem(Map<String, dynamic> workout) {
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
        color: const Color(0xFF8D86C9).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8D86C9).withValues(alpha: 0.2),
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
                          const Color(0xFF8D86C9).withValues(alpha: opacity),
                          const Color(0xFF9067C6).withValues(alpha: opacity),
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
                            color:
                                const Color(0xFFF7ECE1).withValues(alpha: 0.7),
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
                          color: const Color(0xFFF7ECE1).withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: const Color(0xFFF7ECE1).withValues(alpha: 0.6),
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
                        color: const Color(0xFF9067C6).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF9067C6).withValues(alpha: 0.3),
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

  Widget _buildEmptyWorkoutState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF8D86C9).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8D86C9).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Amicons.lucide_dumbbell,
            size: 48,
            color: const Color(0xFF9067C6).withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          const Text(
            "No tienes rutinas guardadas",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF7ECE1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Genera tu primera rutina personalizada con IA",
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFFF7ECE1).withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
        ],
      ),
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
      debugPrint("Error al formatear fecha: $e");
      return dateStr;
    }
  }

  // Métodos para la integración de IA
  void _showWorkoutSelectorDialog() {
    Get.dialog(
      WorkoutSelectorDialog(
        onGeneratePressed: (String level, String goal, int daysPerWeek,
            String? focusMuscleGroup, String? additionalDetails) {
          _generateWorkout(
              level, goal, daysPerWeek, focusMuscleGroup, additionalDetails);
        },
      ),
    );
  }

  void _showWorkoutSelectorDialogWithPreset(
      String goal, String additionalDetails) {
    // Obtener el nivel del usuario actual
    String level =
        authController.userModel.value?.nivelExperiencia ?? 'principiante';

    // Generar rutina con valores preestablecidos
    _generateWorkout(level, goal, 3, null, additionalDetails);
  }

  void _generateWorkout(String level, String goal, int daysPerWeek,
      String? focusMuscleGroup, String? additionalDetails) {
    // Mostrar el diálogo de carga
    Get.dialog(
      const WorkoutLoadingDialog(),
      barrierDismissible: false,
    );

    // Llamar al controlador para generar la rutina con guardado automático
    workoutController
        .generateWorkout(
      level: level,
      goal: goal,
      daysPerWeek: daysPerWeek,
      muscleGroup: focusMuscleGroup,
      details: additionalDetails,
      autoSave: true, // Activar guardado automático
    )
        .then((_) {
      // Cerrar el diálogo de carga
      Get.back();

      // Verificar si se generó correctamente la rutina
      if (workoutController.hasWorkout.value) {
        // Mostrar la rutina generada
        _showWorkoutDisplay();
      }
    });
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
}
