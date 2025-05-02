import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amicons/amicons.dart';
import 'package:nebula/src/controllers/historyTraining.controller.dart';
import 'package:nebula/src/models/historyExercises.model.dart';
import 'package:nebula/src/models/historyTraining.model.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar el controlador a través de GetX
    final HistoryEntrenamientoController controller =
        Get.put(HistoryEntrenamientoController());

    return Scaffold(
      backgroundColor: const Color(0xFF242038),
      body: RefreshIndicator(
        onRefresh: () => controller.cargarEntrenamientos(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageTitle(),
                const SizedBox(height: 20),
                _buildFilterSection(controller),
                const SizedBox(height: 20),
                _buildStatsSection(controller),
                const SizedBox(height: 20),
                Obx(() => _buildWorkoutHistory(controller)),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
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
            color: const Color(0xFFCAC4CE).withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(HistoryEntrenamientoController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Filtro",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF7ECE1),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: DropdownButton<String>(
                value: controller.selectedTimeFrame,
                icon:
                    const Icon(Icons.arrow_drop_down, color: Color(0xFFCAC4CE)),
                elevation: 16,
                style: const TextStyle(color: Color(0xFFF7ECE1)),
                underline: Container(),
                dropdownColor: const Color(0xFF242038),
                isExpanded: true,
                onChanged: (value) {
                  if (value != null) {
                    controller.setSelectedTimeFrame(value);
                  }
                },
                items: HistoryEntrenamientoController.timeFrames
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )),
      ],
    );
  }

  Widget _buildStatsSection(HistoryEntrenamientoController controller) {
    return Obx(() => Container(
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
                color: Colors.black.withValues(alpha: 0.3),
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
                            color:
                                const Color(0xFFF7ECE1).withValues(alpha: 0.8),
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
                  _buildStatItem("${controller.entrenamientosMes}",
                      "Entrenamientos\neste mes", Icons.calendar_month),
                  _buildStatItem(
                      "${controller.cumplimientoMeta.toStringAsFixed(0)}%",
                      "Cumplimiento\nde meta",
                      Icons.track_changes),
                  _buildStatItem("${controller.tiempoTotal}h", "Tiempo\ntotal",
                      Icons.timer),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ));
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
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
            color: const Color(0xFFF7ECE1).withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWorkoutHistory(HistoryEntrenamientoController controller) {
    if (controller.cargando) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF9067C6)));
    }

    if (controller.tieneError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              "Error al cargar los entrenamientos: ${controller.error}",
              style: const TextStyle(color: Color(0xFFF7ECE1)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.cargarEntrenamientos(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9067C6),
              ),
              child: const Text("Reintentar"),
            ),
          ],
        ),
      );
    }

    final entrenamientos = controller.entrenamientosFiltrados;

    if (entrenamientos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center,
                color: Colors.grey.withValues(alpha: 0.5), size: 64),
            const SizedBox(height: 16),
            const Text(
              "No hay entrenamientos en el historial",
              style: TextStyle(color: Color(0xFFF7ECE1), fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

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
            Text(
              "${entrenamientos.length} entrenamiento(s)",
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFFCAC4CE).withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...entrenamientos.map((entrenamiento) => _buildWorkoutCard(
              controller,
              entrenamiento,
            )),
      ],
    );
  }

  Widget _buildWorkoutCard(HistoryEntrenamientoController controller,
      HistoryEntrenamiento entrenamiento) {
    // Para demo, asignamos un tipo aleatorio y un icono basado en el primer carácter del nombre
    final tipos = ["Fuerza", "Cardio", "Flexibilidad", "Personalizado"];
    final tipo = tipos[entrenamiento.nombre.length % tipos.length];

    IconData getIconBasedOnType(String tipo) {
      switch (tipo) {
        case "Fuerza":
          return Icons.fitness_center;
        case "Cardio":
          return Icons.directions_run;
        case "Flexibilidad":
          return Icons.self_improvement;
        default:
          return Amicons.iconly_add_user_curved_fill;
      }
    }

    Color getColorBasedOnType(String tipo) {
      switch (tipo) {
        case "Fuerza":
          return Colors.blue.withValues(alpha: 0.4);
        case "Cardio":
          return Colors.green.withValues(alpha: 0.4);
        case "Flexibilidad":
          return Colors.purple.withValues(alpha: 0.4);
        default:
          return Colors.orange.withValues(alpha: 0.4);
      }
    }

    final icon = getIconBasedOnType(tipo);
    final color = getColorBasedOnType(tipo);

    // Para demo, usamos una fecha reciente
    final date = DateTime.now()
        .subtract(Duration(days: entrenamiento.nombre.length % 10));
    final DateFormat formatter = DateFormat('dd MMM, yyyy');
    final String formattedDate = formatter.format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
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
                      entrenamiento.nombre,
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
                        color: const Color(0xFFCAC4CE).withValues(alpha: 0.8),
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
              _buildWorkoutDetail(
                  Icons.timer, "${entrenamiento.ejercicios.length} series"),
              const SizedBox(width: 15),
              _buildWorkoutDetail(Icons.fitness_center,
                  "${entrenamiento.ejercicios.length} ejercicios"),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF9067C6).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tipo,
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
                  _showWorkoutDetailModal(
                    Get.context!,
                    entrenamiento: entrenamiento,
                    date: date,
                    icon: icon,
                    color: color,
                    tipo: tipo,
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
            color: const Color(0xFFCAC4CE).withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  void _showWorkoutDetailModal(
    BuildContext context, {
    required HistoryEntrenamiento entrenamiento,
    required DateTime date,
    required IconData icon,
    required Color color,
    required String tipo,
  }) {
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
              color: Colors.black.withValues(alpha: 0.2),
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
                  color: Colors.white.withValues(alpha: 0.3),
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
                    color: Colors.white.withValues(alpha: 0.1),
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
                              entrenamiento.nombre,
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
                                color: const Color(0xFFCAC4CE)
                                    .withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                    ...entrenamiento.ejercicios
                        .map((ejercicio) => _buildExerciseItem(ejercicio)),
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
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Buena sesión de entrenamiento. Para la próxima, intentar mejorar la técnica.",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFF7ECE1).withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botones de acción
          ],
        ),
      ),
    );
  }

  // Widget para mostrar cada ejercicio en la lista
  Widget _buildExerciseItem(HistoryEjercicio ejercicio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF9067C6).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Color(0xFF9067C6),
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ejercicio.nombre,
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
                        "${ejercicio.series} series", Icons.repeat),
                    const SizedBox(width: 15),
                    _buildExerciseDetail("${ejercicio.repeticiones} reps",
                        Icons.format_list_numbered),
                    const SizedBox(width: 12),
                    _buildExerciseDetail(ejercicio.dia, Icons.view_day),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
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
            color: const Color(0xFFCAC4CE).withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
