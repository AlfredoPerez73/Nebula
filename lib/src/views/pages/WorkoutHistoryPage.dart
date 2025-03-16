import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amicons/amicons.dart';
import '../../controllers/user.controller.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({Key? key}) : super(key: key);

  @override
  State<WorkoutHistoryPage> createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController searchController = TextEditingController();
  String selectedTimeFrame = "Todos";
  String selectedType = "Todos";

  // Lista de marcos temporales para filtrar
  final List<String> timeFrames = [
    "Todos",
    "Esta semana",
    "Este mes",
    "Este año"
  ];

  // Lista de tipos de entrenamiento
  final List<String> workoutTypes = [
    "Todos",
    "Fuerza",
    "Cardio",
    "Flexibilidad",
    "Personalizado"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF242038),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageTitle(),
                const SizedBox(height: 20),
                // Eliminar estas dos líneas:
                // _buildSearchBar(),
                // const SizedBox(height: 20),
                // _buildSearchBar(),
                // const SizedBox(height: 20),
                _buildFilterSection(),
                const SizedBox(height: 20),
                _buildStatsSection(),
                const SizedBox(height: 20),
                _buildWorkoutHistory(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Historial de Entrenamientos",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ECE1),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Seguimiento de tus rutinas y progreso",
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
          hintText: "Buscar entrenamientos...",
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
                "Período",
                selectedTimeFrame,
                timeFrames,
                (value) {
                  setState(() {
                    selectedTimeFrame = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildFilterDropdown(
                "Tipo",
                selectedType,
                workoutTypes,
                (value) {
                  setState(() {
                    selectedType = value!;
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

  Widget _buildStatsSection() {
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
              const Icon(
                Icons.bar_chart_rounded,
                color: Color(0xFFF7ECE1),
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Estadísticas de Entrenamiento",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF7ECE1),
                      ),
                    ),
                    Text(
                      "Resumen de tu actividad reciente",
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                  "8", "Entrenamientos\neste mes", Icons.calendar_month),
              _buildStatItem(
                  "67%", "Cumplimiento\nde meta", Icons.track_changes),
              _buildStatItem("4.5h", "Tiempo\ntotal", Icons.timer),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ECE1),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFFF7ECE1).withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWorkoutHistory() {
    // Datos simulados de historial de entrenamientos
    final workouts = [
      {
        "date": DateTime.now().subtract(const Duration(days: 1)),
        "name": "Entrenamiento de fuerza",
        "duration": "45 min",
        "exercises": 8,
        "type": "Fuerza",
        "icon": Icons.fitness_center,
        "color": Colors.blue.withOpacity(0.4),
      },
      {
        "date": DateTime.now().subtract(const Duration(days: 3)),
        "name": "Cardio HIIT",
        "duration": "30 min",
        "exercises": 6,
        "type": "Cardio",
        "icon": Icons.directions_run,
        "color": Colors.green.withOpacity(0.4),
      },
      {
        "date": DateTime.now().subtract(const Duration(days: 5)),
        "name": "Yoga matutino",
        "duration": "50 min",
        "exercises": 10,
        "type": "Flexibilidad",
        "icon": Icons.self_improvement,
        "color": Colors.purple.withOpacity(0.4),
      },
      {
        "date": DateTime.now().subtract(const Duration(days: 7)),
        "name": "Entrenamiento completo",
        "duration": "60 min",
        "exercises": 12,
        "type": "Personalizado",
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
              "Historial",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF7ECE1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...workouts.map((workout) => _buildWorkoutCard(
              workout["date"] as DateTime,
              workout["name"] as String,
              workout["duration"] as String,
              workout["exercises"] as int,
              workout["type"] as String,
              workout["icon"] as IconData,
              workout["color"] as Color,
            )),
      ],
    );
  }

  Widget _buildWorkoutCard(DateTime date, String name, String duration,
      int exercises, String type, IconData icon, Color color) {
    final DateFormat formatter = DateFormat('dd MMM, yyyy');
    final String formattedDate = formatter.format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFFCAC4CE).withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildWorkoutDetail(Icons.timer, duration),
              const SizedBox(width: 15),
              _buildWorkoutDetail(
                  Icons.fitness_center, "$exercises ejercicios"),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF9067C6).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  type,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFF7ECE1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  // Aquí llamamos a la función del modal
                  _showWorkoutDetailModal(
                    context,
                    date: date,
                    name: name,
                    duration: duration,
                    exercises: exercises,
                    type: type,
                    icon: icon,
                    color: color,
                  );
                },
                icon: const Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: Color(0xFF9067C6),
                ),
                label: const Text(
                  "Ver detalles",
                  style: TextStyle(
                    color: Color(0xFF9067C6),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFFCAC4CE),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFFCAC4CE).withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // Añade esta función a tu clase _WorkoutHistoryPageState

  void _showWorkoutDetailModal(
    BuildContext context, {
    required DateTime date,
    required String name,
    required String duration,
    required int exercises,
    required String type,
    required IconData icon,
    required Color color,
  }) {
    // Lista de ejercicios simulados para el entrenamiento
    final List<Map<String, dynamic>> exercisesList = [
      {
        "name": "Sentadillas",
        "series": 4,
        "reps": "12",
        "weight": "50kg",
        "completed": true,
      },
      {
        "name": "Peso muerto",
        "series": 3,
        "reps": "10",
        "weight": "60kg",
        "completed": true,
      },
      {
        "name": "Press de banca",
        "series": 4,
        "reps": "8",
        "weight": "45kg",
        "completed": true,
      },
      {
        "name": "Elevaciones laterales",
        "series": 3,
        "reps": "15",
        "weight": "8kg",
        "completed": true,
      },
    ];

    final DateFormat formatter = DateFormat('dd MMM, yyyy');
    final String formattedDate = formatter.format(date);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: const Color(0xFF242038),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra superior con indicador de arrastre
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Cabecera con información principal
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          size: 28,
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF7ECE1),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color(0xFFCAC4CE).withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWorkoutDetailStat(
                        Icons.timer,
                        duration,
                        "Duración",
                      ),
                      _buildWorkoutDetailStat(
                        Icons.fitness_center,
                        "$exercises",
                        "Ejercicios",
                      ),
                      _buildWorkoutDetailStat(
                        Icons.local_fire_department,
                        "320",
                        "Calorías",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Sección de ejercicios
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ejercicios",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF7ECE1),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...exercisesList
                        .map((exercise) => _buildExerciseItem(exercise)),
                    const SizedBox(height: 20),
                    const Text(
                      "Notas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF7ECE1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Buena sesión de entrenamiento. Aumenté peso en sentadillas y press de banca. Para la próxima, intentar mejorar la técnica en el peso muerto.",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFF7ECE1).withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botones de acción
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.repeat),
                      label: const Text("Repetir entrenamiento"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9067C6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Widget de estadísticas para el modal
  Widget _buildWorkoutDetailStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF9067C6),
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ECE1),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFFCAC4CE).withOpacity(0.8),
          ),
        ),
      ],
    );
  }

// Widget para mostrar cada ejercicio en la lista
  Widget _buildExerciseItem(Map<String, dynamic> exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF9067C6).withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.fitness_center,
              color: const Color(0xFF9067C6),
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF7ECE1),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _buildExerciseDetail(
                        "${exercise["series"]} series", Icons.repeat),
                    const SizedBox(width: 15),
                    _buildExerciseDetail(
                        "${exercise["reps"]} reps", Icons.format_list_numbered),
                    const SizedBox(width: 15),
                    _buildExerciseDetail(
                        exercise["weight"], Icons.fitness_center),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            exercise["completed"] ? Icons.check_circle : Icons.circle_outlined,
            color:
                exercise["completed"] ? Colors.green : const Color(0xFFCAC4CE),
            size: 24,
          ),
        ],
      ),
    );
  }

// Widget para mostrar detalles del ejercicio
  Widget _buildExerciseDetail(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: const Color(0xFFCAC4CE),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFFCAC4CE).withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
