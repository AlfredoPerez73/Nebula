import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../controllers/workoutstats.dart'; // Ajusta la ruta según tu estructura

class WorkoutStatsWidget extends StatelessWidget {
  const WorkoutStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializa o encuentra el controlador
    final WorkoutStatsController statsController =
        Get.put(WorkoutStatsController());
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Estadísticas de entrenos",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                  letterSpacing: 0.6,
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
          const SizedBox(height: 30),

          // Primer gráfico: Ejercicios por día
          _sectionHeader("Ejercicios por Día", Icons.fitness_center),
          const SizedBox(height: 20),
          SizedBox(
            height: 220,
            child: _buildExercisesPerDayChart(),
          ),

          const SizedBox(height: 40),

          // Segundo gráfico: Series totales por día (ahora como pie chart)
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
    // Datos estáticos de ejemplo
    final exercisesData = [
      _DailyStats(DateTime.now().subtract(const Duration(days: 6)), 3),
      _DailyStats(DateTime.now().subtract(const Duration(days: 5)), 5),
      _DailyStats(DateTime.now().subtract(const Duration(days: 4)), 2),
      _DailyStats(DateTime.now().subtract(const Duration(days: 3)), 6),
      _DailyStats(DateTime.now().subtract(const Duration(days: 2)), 4),
      _DailyStats(DateTime.now().subtract(const Duration(days: 1)), 7),
      _DailyStats(DateTime.now(), 5),
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY:
            exercisesData.map((e) => e.value).reduce((a, b) => a > b ? a : b) *
                1.2,
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
                      DateFormat('E').format(exercisesData[index].date),
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
                  toY: exercisesData
                          .map((e) => e.value)
                          .reduce((a, b) => a > b ? a : b) *
                      1.2,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ],
            showingTooltipIndicators: stat.value ==
                    exercisesData
                        .map((e) => e.value)
                        .reduce((a, b) => a > b ? a : b)
                ? [0]
                : [],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSetsPieChart() {
    // Datos estáticos de ejemplo
    final setsData = [
      _DailyStats(DateTime.now().subtract(const Duration(days: 6)), 9),
      _DailyStats(DateTime.now().subtract(const Duration(days: 5)), 15),
      _DailyStats(DateTime.now().subtract(const Duration(days: 4)), 6),
      _DailyStats(DateTime.now().subtract(const Duration(days: 3)), 18),
      _DailyStats(DateTime.now().subtract(const Duration(days: 2)), 12),
      _DailyStats(DateTime.now().subtract(const Duration(days: 1)), 21),
      _DailyStats(DateTime.now(), 15),
    ];

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
    final int totalSets = setsData.map((e) => e.value).reduce((a, b) => a + b);

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
                final percentage = (stat.value / totalSets) * 100;

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
                  badgeWidget: index == 0 ? const _Badge() : null,
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

class _DailyStats {
  final DateTime date;
  final int value;

  _DailyStats(this.date, this.value);
}
