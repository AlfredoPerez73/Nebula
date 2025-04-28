import 'package:flutter/material.dart';
import 'package:amicons/amicons.dart';
import 'package:get/get.dart';
import '../../controllers/ai_exercise.controller.dart';

class WorkoutDisplayWidget extends StatefulWidget {
  final Map<String, dynamic> workoutData;
  final VoidCallback onClose;

  const WorkoutDisplayWidget({
    Key? key,
    required this.workoutData,
    required this.onClose,
  }) : super(key: key);

  @override
  State<WorkoutDisplayWidget> createState() => _WorkoutDisplayWidgetState();
}

class _WorkoutDisplayWidgetState extends State<WorkoutDisplayWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedDayIndex = 0;

  // Controlador de rutinas para guardar
  final WorkoutRoutineController workoutController =
      Get.find<WorkoutRoutineController>();

  // Estado para mostrar si la rutina está guardada
  bool _isSaved = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Inicializar el controlador de tabs para los días de entrenamiento
    final days = _getWorkoutDays();
    _tabController = TabController(length: days.length, vsync: this);

    // Añadir listener para cambio de tab
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedDayIndex = _tabController.index;
        });
      }
    });

    // Guardar automáticamente la rutina cuando se muestra
    _autoSaveWorkout();
  }

  // Método para guardar automáticamente la rutina
  Future<void> _autoSaveWorkout() async {
    // Verificar si la rutina ya tiene ID (ya está guardada)
    if (widget.workoutData.containsKey('id')) {
      setState(() => _isSaved = true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Guardar la rutina sin mostrar mensaje al usuario
      final success = await workoutController.saveWorkout(showMessage: false);
      setState(() {
        _isSaved = success;
        _isSaving = false;
      });
    } catch (e) {
      setState(() => _isSaving = false);
      print('Error al guardar rutina automáticamente: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getWorkoutDays() {
    try {
      final List<dynamic> days =
          widget.workoutData['workoutDays'] as List<dynamic>;
      return days.map((day) => day as Map<String, dynamic>).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final workoutDays = _getWorkoutDays();

    if (workoutDays.isEmpty) {
      return Center(
        child: Text(
          "No se encontraron días de entrenamiento",
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF242038),
      child: Column(
        children: [
          // Barra superior
          _buildAppBar(),

          // Encabezado de la rutina
          _buildRoutineHeader(),

          // Tabs para días de entrenamiento
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: const Color(0xFFF7ECE1),
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              indicatorColor: const Color(0xFF9067C6),
              indicatorWeight: 3,
              tabs: workoutDays.map((day) {
                return Tab(
                  text: day["day"] as String? ?? "Día",
                );
              }).toList(),
            ),
          ),

          // Contenido del día seleccionado
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: workoutDays.map((day) {
                return _buildDayContent(day);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFF7ECE1),
            ),
            onPressed: widget.onClose,
          ),
          // Indicador de guardado
          _buildSaveIndicator(),
        ],
      ),
    );
  }

  // Widget para mostrar el estado de guardado
  Widget _buildSaveIndicator() {
    if (_isSaving) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.8)),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "Guardando...",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    } else if (_isSaved) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0xFF4CAF50),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              "Guardada",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    } else {
      return IconButton(
        icon: Icon(
          Icons.save_alt,
          color: Colors.white.withOpacity(0.8),
          size: 22,
        ),
        onPressed: () async {
          setState(() => _isSaving = true);
          final success = await workoutController.saveWorkout();
          setState(() {
            _isSaving = false;
            _isSaved = success;
          });
        },
      );
    }
  }

  Widget _buildRoutineHeader() {
    final routineName =
        widget.workoutData['routineName'] as String? ?? "Rutina personalizada";
    final routineDescription =
        widget.workoutData['description'] as String? ?? "";
    final level = widget.workoutData['level'] as String? ?? "";
    final daysPerWeek = widget.workoutData['daysPerWeek']?.toString() ?? "";

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            routineName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF9067C6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Amicons.lucide_dumbbell,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nivel: $level • $daysPerWeek días por semana",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (routineDescription.isNotEmpty)
            Text(
              routineDescription,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                height: 1.3,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDayContent(Map<String, dynamic> day) {
    final String focus = day["focus"] as String? ?? "Entrenamiento";
    final String notes = day["notes"] as String? ?? "";
    List<dynamic> exercises = [];

    // Verificar si hay ejercicios para este día
    if (day.containsKey("exercises") && day["exercises"] is List) {
      exercises = day["exercises"] as List<dynamic>;
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enfoque del día
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF9067C6).withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFF9067C6).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9067C6).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Amicons.lucide_target,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enfoque",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFCAC4CE),
                        ),
                      ),
                      Text(
                        focus,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF7ECE1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Notas del día (si existen)
            if (notes.isNotEmpty) ...[
              Text(
                "Notas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
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
                  notes,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Lista de ejercicios
            Text(
              "Ejercicios",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 10),

            if (exercises.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "No hay ejercicios para este día",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index] as Map<String, dynamic>;
                  return _buildExerciseCard(exercise, index + 1);
                },
              ),

            const SizedBox(height: 30),

            // Información adicional
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, dynamic> exercise, int index) {
    final String name = exercise["name"] as String? ?? "Ejercicio";
    final String muscle = exercise["muscle"] as String? ?? "";
    final int sets = exercise["sets"] is int ? exercise["sets"] as int : 3;
    final String reps = exercise["reps"] as String? ?? "10-12";
    final String rest = exercise["rest"] as String? ?? "60s";
    final String notes = exercise["notes"] as String? ?? "";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF9067C6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                index.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9067C6),
                ),
              ),
            ),
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),
          subtitle: Row(
            children: [
              if (muscle.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9067C6).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // Usar un ancho máximo para forzar el salto de línea
                  constraints: const BoxConstraints(
                    maxWidth: 200, // Ajusta este valor según tus necesidades
                  ),
                  child: Text(
                    muscle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    softWrap: true, // Permite el salto de línea
                    overflow: TextOverflow.visible, // No corta el texto
                  ),
                ),
            ],
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          children: [
            const Divider(color: Color(0xFF9067C6), thickness: 0.5),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildExerciseDetail("Series", sets.toString(),
                    Amicons.flaticon_add_rounded_fill),
                _buildExerciseDetail(
                    "Repeticiones", reps, Amicons.flaticon_add_sharp),
                _buildExerciseDetail(
                    "Descanso", rest, Amicons.iconly_time_circle_broken),
              ],
            ),
            if (notes.isNotEmpty) ...[
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Amicons.iconly_info_square_broken,
                    color: Color(0xFF9067C6),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      notes,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF9067C6).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF9067C6),
            size: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ECE1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    final String nutritionTips =
        widget.workoutData['nutritionTips'] as String? ?? "";
    final String restDayTips =
        widget.workoutData['restDayTips'] as String? ?? "";

    if (nutritionTips.isEmpty && restDayTips.isEmpty) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Información adicional",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                ),
              ),
              // Aquí ya no se necesita un botón de guardar,
              // ya que se guarda automáticamente
            ],
          ),
          const SizedBox(height: 15),

          // Consejos nutricionales
          if (nutritionTips.isNotEmpty) ...[
            _buildInfoSection(
                "Nutrición", nutritionTips, Amicons.lucide_utensils),
            const SizedBox(height: 15),
          ],

          // Consejos para días de descanso
          if (restDayTips.isNotEmpty) ...[
            _buildInfoSection("Días de descanso", restDayTips,
                Amicons.lucide_battery_charging),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF9067C6).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF9067C6),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF7ECE1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
