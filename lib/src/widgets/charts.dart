import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../controllers/workoutstats.dart'; // Asegúrate de que la ruta sea correcta

class WorkoutStatsWidget extends StatefulWidget {
  const WorkoutStatsWidget({Key? key}) : super(key: key);

  @override
  State<WorkoutStatsWidget> createState() => _WorkoutStatsWidgetState();
}

class _WorkoutStatsWidgetState extends State<WorkoutStatsWidget>
    with WidgetsBindingObserver {
  late final WorkoutStatsController statsController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Registrar el observador del ciclo de vida
    WidgetsBinding.instance.addObserver(this);

    // Inicializar el controlador
    statsController = Get.put(WorkoutStatsController());

    // Cargar datos iniciales
    _cargarDatos();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Cuando la app vuelve a estar activa, actualizar los datos
    if (state == AppLifecycleState.resumed) {
      _cargarDatos();
    }
  }

  @override
  void didUpdateWidget(WorkoutStatsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recargar datos cuando el widget se actualiza
    _cargarDatos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Este método se llama cuando el widget es insertado en el árbol
    // o cuando cualquier dependencia cambia (incluyendo cuando cambia la ruta)
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Limpiar cualquier dato previo
      statsController.clearData();

      // Cargar datos nuevos
      await statsController.loadDataFromFirebase();
    } catch (e) {
      // Manejo de errores silencioso
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Eliminar el observador al destruir el widget
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Estadísticas",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF7ECE1),
                        letterSpacing: 0.6,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await statsController.refreshData();
                              Get.snackbar(
                                'Actualizado',
                                'Estadísticas actualizadas correctamente',
                                backgroundColor: Colors.green.withOpacity(0.7),
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(20),
                                borderRadius: 10,
                                duration: const Duration(seconds: 2),
                              );
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'No se pudieron actualizar las estadísticas: ${e.toString()}',
                                backgroundColor: Colors.red.withOpacity(0.7),
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(20),
                                borderRadius: 10,
                                duration: const Duration(seconds: 3),
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9067C6).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.refresh,
                              color: Color(0xFFF7ECE1),
                              size: 22,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8D86C9).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.bar_chart,
                            color: Color(0xFFF7ECE1),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Primer gráfico: Ejercicios por día
                _sectionHeader("Ejercicios por Día", Icons.fitness_center),
                const SizedBox(height: 20),
                SizedBox(
                  height: 220,
                  child: _buildExercisesPerDayChart(),
                ),

                const SizedBox(height: 40),

                // Segundo gráfico: Series totales por día
                _sectionHeader("Series Totales por Día", Icons.pie_chart),
                const SizedBox(height: 20),
                SizedBox(
                  height: 280,
                  child: _buildSetsPieChart(),
                ),
              ],
            ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF725AC1).withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFF7ECE1),
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF7ECE1),
          ),
        ),
      ],
    );
  }

  Widget _buildExercisesPerDayChart() {
    return Obx(() {
      final exercisesData = statsController.exercisesPerDay;

      if (exercisesData.isEmpty ||
          !exercisesData.any((element) => element.value > 0)) {
        return const Center(
          child: Text(
            "No hay datos de ejercicios disponibles",
            style: TextStyle(
              color: Color(0xFFF7ECE1),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      final maxY =
          exercisesData.map((e) => e.value).reduce((a, b) => a > b ? a : b) *
              1.2;

      return BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipRoundedRadius: 12,
              tooltipPadding: const EdgeInsets.all(12),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${exercisesData[groupIndex].value} ejercicios\n${DateFormat('EEEE').format(exercisesData[groupIndex].date)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < exercisesData.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        exercisesData[index].getFormattedDate('E'),
                        style: const TextStyle(
                          color: Color(0xFFCAC4CE),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 35,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value % 1 == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Color(0xFFCAC4CE),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 35,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white.withOpacity(0.1),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
            drawVerticalLine: false,
          ),
          barGroups: exercisesData.asMap().entries.map((entry) {
            final index = entry.key;
            final stat = entry.value;
            final maxValue = exercisesData
                .map((e) => e.value)
                .reduce((a, b) => a > b ? a : b);

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: stat.value.toDouble(),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9067C6), Color(0xFFAA8FD8)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 20,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ],
              showingTooltipIndicators: stat.value == maxValue ? [0] : [],
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildSetsPieChart() {
    return Obx(() {
      final setsData = statsController.setsPerDay;

      if (setsData.isEmpty || !setsData.any((element) => element.value > 0)) {
        return const Center(
          child: Text(
            "No hay datos de series disponibles",
            style: TextStyle(
              color: Color(0xFFF7ECE1),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      // Colores para cada sección del pie chart
      final List<Color> pieColors = [
        const Color(0xFF725AC1),
        const Color(0xFF8D86C9),
        const Color(0xFF9067C6),
        const Color(0xFFAA8FD8),
        const Color(0xFFBA9FE6),
        const Color(0xFFC9B6E4),
        const Color(0xFFD7C1F0),
      ];

      // Calcular el total para porcentajes
      final int totalSets =
          setsData.map((e) => e.value).reduce((a, b) => a + b);

      // Encontrar el día con más series para el badge
      final maxIndex = setsData
          .indexOf(setsData.reduce((a, b) => a.value > b.value ? a : b));

      return Row(
        children: [
          // Pie chart
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                startDegreeOffset: -90,
                sections: setsData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stat = entry.value;
                  final percentage =
                      totalSets > 0 ? (stat.value / totalSets) * 100 : 0;

                  return PieChartSectionData(
                    color: pieColors[index % pieColors.length],
                    value: stat.value.toDouble(),
                    title: '${percentage.toStringAsFixed(1)}%',
                    radius: 100,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black38,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                    borderSide: const BorderSide(
                      color: Color(0xFF2A2D3E),
                      width: 1,
                    ),
                    badgeWidget: index == maxIndex ? const _Badge() : null,
                    badgePositionPercentageOffset: 1.2,
                  );
                }).toList(),
              ),
            ),
          ),

          // Leyenda
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: setsData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stat = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: pieColors[index % pieColors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            DateFormat('E, d MMM').format(stat.date),
                            style: const TextStyle(
                              color: Color(0xFFCAC4CE),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          '${stat.value}',
                          style: const TextStyle(
                            color: Color(0xFFF7ECE1),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// Badge widget para destacar una sección
class _Badge extends StatelessWidget {
  const _Badge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(
        Icons.star,
        color: Color(0xFFFFD700),
        size: 16,
      ),
    );
  }
}
