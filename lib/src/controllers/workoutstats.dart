import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WorkoutStatsController extends GetxController {
  // Observable para los datos de ejercicios por día
  final exercisesPerDay = <DailyStats>[].obs;

  // Observable para los datos de series por día
  final setsPerDay = <DailyStats>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Cargar datos de ejemplo al inicializar el controlador
    loadMockData();
  }

  // Método para cargar datos de ejemplo (simulando datos de la base de datos)
  void loadMockData() {
    // Datos de ejemplo para ejercicios por día
    exercisesPerDay.value = [
      DailyStats(DateTime.now().subtract(const Duration(days: 6)), 3),
      DailyStats(DateTime.now().subtract(const Duration(days: 5)), 5),
      DailyStats(DateTime.now().subtract(const Duration(days: 4)), 2),
      DailyStats(DateTime.now().subtract(const Duration(days: 3)), 6),
      DailyStats(DateTime.now().subtract(const Duration(days: 2)), 4),
      DailyStats(DateTime.now().subtract(const Duration(days: 1)), 7),
      DailyStats(DateTime.now(), 5),
    ];

    // Datos de ejemplo para series por día
    setsPerDay.value = [
      DailyStats(DateTime.now().subtract(const Duration(days: 6)), 9),
      DailyStats(DateTime.now().subtract(const Duration(days: 5)), 15),
      DailyStats(DateTime.now().subtract(const Duration(days: 4)), 6),
      DailyStats(DateTime.now().subtract(const Duration(days: 3)), 18),
      DailyStats(DateTime.now().subtract(const Duration(days: 2)), 12),
      DailyStats(DateTime.now().subtract(const Duration(days: 1)), 21),
      DailyStats(DateTime.now(), 15),
    ];
  }

  // Método para cargar datos reales de la base de datos
  // Este método será implementado cuando tengas el acceso a la base de datos
  Future<void> loadDataFromDatabase() async {
    try {
      // Aquí iría la lógica para obtener datos de la base de datos
      // Por ejemplo:
      // final workoutData = await workoutRepository.getUserWorkoutStats();
      // exercisesPerDay.value = workoutData.exercisesPerDay;
      // setsPerDay.value = workoutData.setsPerDay;

      // Mientras tanto, usamos los datos de ejemplo
      loadMockData();
    } catch (e) {
      print('Error al cargar datos de entrenamiento: $e');
      // En caso de error, cargar datos de ejemplo
      loadMockData();
    }
  }

  // Método para obtener el valor máximo de ejercicios (para escalar el gráfico)
  int get maxExercisesValue {
    if (exercisesPerDay.isEmpty) return 10;
    return exercisesPerDay.map((e) => e.value).reduce((a, b) => a > b ? a : b);
  }

  // Método para obtener el valor máximo de series (para escalar el gráfico)
  int get maxSetsValue {
    if (setsPerDay.isEmpty) return 20;
    return setsPerDay.map((e) => e.value).reduce((a, b) => a > b ? a : b);
  }

  // Método para actualizar los datos periódicamente
  void refreshData() {
    loadDataFromDatabase();
  }
}

// Clase para representar estadísticas diarias
class DailyStats {
  final DateTime date;
  final int value;

  DailyStats(this.date, this.value);

  // Método de utilidad para formatear la fecha
  String getFormattedDate(String format) {
    return DateFormat(format).format(date);
  }
}
