import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amicons/amicons.dart';
import 'package:nebula/src/controllers/ai_exercise.controller.dart';
import '../../controllers/user.controller.dart';
import '../../controllers/historyTraining.controller.dart';
import '../../services/ai_recommendation_service.dart';

import '../../widgets/workout_display_widget.dart';
import '../../widgets/workout_loading_dialog.dart';
import '../../widgets/workout_selector_dialog.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({Key? key}) : super(key: key);

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final AuthController authController = Get.find<AuthController>();
  final WorkoutRoutineController workoutController = Get.put(WorkoutRoutineController());
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageTitle(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildFilterSection(),
            const SizedBox(height: 20),
            _buildAIRecommendationSection(),
            const SizedBox(height: 20),
            _buildExercisesList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ejercicios",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ECE1),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Explora ejercicios personalizados para tu nivel y objetivos",
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFFCAC4CE).withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Color(0xFFF7ECE1)),
        decoration: const InputDecoration(
          hintText: "Buscar ejercicios...",
          hintStyle: TextStyle(color: Color(0xFFCAC4CE)),
          icon: Icon(Icons.search, color: Color(0xFFCAC4CE)),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          // Implementar búsqueda
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Filtros",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ECE1),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildFilterDropdown(
                "Nivel",
                selectedCategory,
                categories,
                (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildFilterDropdown(
                "Grupo muscular",
                selectedMuscleGroup,
                muscleGroups,
                (value) {
                  setState(() {
                    selectedMuscleGroup = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFFCAC4CE).withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: DropdownButton<String>(
            value: value,
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFCAC4CE)),
            elevation: 16,
            style: const TextStyle(color: Color(0xFFF7ECE1)),
            underline: Container(),
            dropdownColor: const Color(0xFF242038),
            isExpanded: true,
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAIRecommendationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8D86C9),
            Color(0xFF9067C6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Amicons.lucide_brain,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Recomendación IA",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF7ECE1),
                      ),
                    ),
                    Text(
                      "Basado en tu perfil y objetivos",
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFFF7ECE1).withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Obx(() => Text(
                "Para tu nivel ${authController.userModel.value?.nivelExperiencia ?? 'principiante'} y tu objetivo de ${authController.userModel.value?.objetivo ?? 'mantenimiento'}, te recomendamos:",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFF7ECE1),
                ),
              )),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              // Mostrar el diálogo de selección de rutina
              _showWorkoutSelectorDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF9067C6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Amicons.lucide_brain, size: 18),
                SizedBox(width: 8),
                Text("Generar rutina personalizada"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExercisesList() {
    // Lista simulada de ejercicios
    final exercises = [
      {
        "name": "Sentadillas",
        "muscle": "Piernas",
        "level": "Principiante",
        "icon": Amicons.iconly_add_user_curved_fill,
        "color": Colors.blue.withOpacity(0.4),
      },
      {
        "name": "Press de banca",
        "muscle": "Pecho",
        "level": "Intermedio",
        "icon": Amicons.iconly_add_user_curved_fill,
        "color": Colors.purple.withOpacity(0.4),
      },
      {
        "name": "Dominadas",
        "muscle": "Espalda",
        "level": "Avanzado",
        "icon": Amicons.iconly_add_user_curved_fill,
        "color": Colors.green.withOpacity(0.4),
      },
      {
        "name": "Curl de bíceps",
        "muscle": "Brazos",
        "level": "Principiante",
        "icon": Amicons.iconly_add_user_curved_fill,
        "color": Colors.orange.withOpacity(0.4),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Ejercicios",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF7ECE1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...exercises.map((exercise) => _buildExerciseCard(
              exercise["name"] as String,
              exercise["muscle"] as String,
              exercise["level"] as String,
              exercise["icon"] as IconData,
              exercise["color"] as Color,
            )),
      ],
    );
  }

  Widget _buildExerciseCard(
      String name, String muscle, String level, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF7ECE1),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8D86C9).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        muscle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFF7ECE1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9067C6).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        level,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFF7ECE1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFCAC4CE),
              size: 16,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPopularExerciseCard(
      String name, String muscle, IconData icon, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF8D86C9).withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              muscle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFF7ECE1),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Métodos para la integración de IA
  void _showWorkoutSelectorDialog() {
    Get.dialog(
      WorkoutSelectorDialog(
        onGeneratePressed: (String level, String goal, int daysPerWeek, String? focusMuscleGroup, String? additionalDetails) {
          // Mostrar el diálogo de carga
          Get.dialog(
            const WorkoutLoadingDialog(),
            barrierDismissible: false,
          );
          
          // Llamar al controlador para generar la rutina
          workoutController.generateWorkout(
            level: level,
            goal: goal,
            daysPerWeek: daysPerWeek,
            muscleGroup: focusMuscleGroup,
            details: additionalDetails,
          ).then((_) {
            // Cerrar el diálogo de carga
            Get.back();
            
            // Verificar si se generó correctamente la rutina
            if (workoutController.hasWorkout.value) {
              // Mostrar la rutina generada
              _showWorkoutDisplay();
            }
          });
        },
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
}