import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nebula/src/controllers/training.controller.dart';

class WorkoutStatsController extends GetxController {
  // Observable para los datos de ejercicios por día
  final exercisesPerDay = <DailyStats>[].obs;

  // Observable para los datos de series por día
  final setsPerDay = <DailyStats>[].obs;

  // Referencia al controlador de entrenamiento
  EntrenamientoController? _entrenamientoController;

  // Getter seguro para el controlador
  EntrenamientoController get entrenamientoController {
    if (_entrenamientoController == null) {
      try {
        _entrenamientoController = Get.find<EntrenamientoController>();
      } catch (e) {
        // Crear una instancia temporal si no se encuentra
        _entrenamientoController = Get.put(EntrenamientoController());
      }
    }
    return _entrenamientoController!;
  }

  @override
  void onInit() {
    super.onInit();

    // Verificamos si EntrenamientoController ya está registrado
    try {
      _entrenamientoController = Get.find<EntrenamientoController>();
    } catch (e) {}

    // Esperamos un poco para asegurar que el controlador esté listo
    Future.delayed(Duration(milliseconds: 500), () {
      loadDataFromFirebase();
    });
  }

  // Cargar datos reales desde Firebase
  Future<void> loadDataFromFirebase() async {
    try {
      // Asegurarse de que los entrenamientos estén cargados
      if (entrenamientoController.entrenamientos.isEmpty) {
        await entrenamientoController.cargarEntrenamientos();
      }

      // Procesar los datos para crear estadísticas basadas en el día de la semana
      procesarDatosDeEntrenamiento();
    } catch (e) {}
  }

  // Procesar los datos de entrenamiento para generar estadísticas
  void procesarDatosDeEntrenamiento() {
    // Usar un Map para almacenar el weekday (1-7) y el nombre del día en español
    final Map<int, String> weekdayToNameMap = {
      1: 'Lun',
      2: 'Mar',
      3: 'Mié',
      4: 'Jue',
      5: 'Vie',
      6: 'Sáb',
      7: 'Dom',
    };

    // Crear mapas para contar ejercicios y series por día
    Map<int, int> ejerciciosPorDia = {}; // Key es weekday (1-7)
    Map<int, int> seriesPorDia = {}; // Key es weekday (1-7)

    // Inicializar con 0 para todos los días de la semana
    for (int weekday = 1; weekday <= 7; weekday++) {
      ejerciciosPorDia[weekday] = 0;
      seriesPorDia[weekday] = 0;
    }

    // Verificar si hay entrenamientos disponibles
    if (entrenamientoController.entrenamientos.isEmpty) {
    } else {
      // Recorrer los entrenamientos del usuario
      for (var entrenamiento in entrenamientoController.entrenamientos) {
        // Verificar si el entrenamiento tiene ejercicios
        if (entrenamiento.ejercicios == null ||
            entrenamiento.ejercicios.isEmpty) {
          continue;
        }

        for (var ejercicio in entrenamiento.ejercicios) {
          // Verificar si el ejercicio tiene un día asignado
          if (ejercicio.dia != null && ejercicio.dia.toString().isNotEmpty) {
            // Obtener el número de día de la semana (1-7) basado en el nombre del día
            int? weekday = _obtenerWeekdayDesdeDia(ejercicio.dia);

            if (weekday != null) {
              // Incrementar contador de ejercicios para este día
              ejerciciosPorDia[weekday] = (ejerciciosPorDia[weekday] ?? 0) + 1;

              // Obtener el número de series para este ejercicio
              int seriesEnEjercicio = _obtenerSeriesDeEjercicio(ejercicio);

              // Incrementar contador de series para este día
              seriesPorDia[weekday] =
                  (seriesPorDia[weekday] ?? 0) + seriesEnEjercicio;
            } else {}
          } else {}
        }
      }
    }

    // Imprimir resumen de los datos recolectados
    ejerciciosPorDia.forEach((weekday, cantidad) {});

    seriesPorDia.forEach((weekday, cantidad) {
      print('  Día $weekday (${weekdayToNameMap[weekday]}): $cantidad series');
    });

    // Obtener la fecha del lunes de esta semana
    DateTime hoy = DateTime.now();
    DateTime lunesDeSemana = hoy.subtract(Duration(days: hoy.weekday - 1));

    // Convertir los mapas a listas ordenadas para los gráficos
    List<DailyStats> listaEjerciciosPorDia = [];
    List<DailyStats> listaSeriesPorDia = [];

    // Reordenar para que la semana comience en martes (para coincidir con tu UI)
    // La UI muestra: Tue, Wed, Thu, Fri, Sat, Sun, Mon
    List<int> ordenDias = [
      2,
      3,
      4,
      5,
      6,
      7,
      1
    ]; // Mar, Mié, Jue, Vie, Sáb, Dom, Lun

    for (int i = 0; i < ordenDias.length; i++) {
      int weekday = ordenDias[i];

      // Calcular la fecha real para este día de la semana
      DateTime fechaDelDia = lunesDeSemana.add(Duration(days: weekday - 1));

      // Añadir estadísticas para este día
      listaEjerciciosPorDia
          .add(DailyStats(fechaDelDia, ejerciciosPorDia[weekday] ?? 0));
      listaSeriesPorDia
          .add(DailyStats(fechaDelDia, seriesPorDia[weekday] ?? 0));
    }

    // Actualizar las variables observables
    exercisesPerDay.value = listaEjerciciosPorDia;
    setsPerDay.value = listaSeriesPorDia;

    update(); // Notificar a la UI
  }

  // Método para obtener el número de día de la semana (1-7) a partir del nombre del día
  int? _obtenerWeekdayDesdeDia(String dia) {
    // Limpiar el texto y convertir a minúsculas para hacer la comparación más robusta
    String diaLimpio = dia.trim().toLowerCase();

    // Mapeo de nombres de días a números de weekday (1=Lunes, 7=Domingo)
    final Map<String, int> diasSemana = {
      'lunes': 1,
      'lun': 1,
      'martes': 2,
      'mar': 2,
      'miercoles': 3,
      'miércoles': 3,
      'mié': 3,
      'mie': 3,
      'jueves': 4,
      'jue': 4,
      'viernes': 5,
      'vie': 5,
      'sabado': 6,
      'sábado': 6,
      'sáb': 6,
      'sab': 6,
      'domingo': 7,
      'dom': 7,
    };

    // Devolver el número de día de la semana correspondiente
    return diasSemana[diaLimpio];
  }

  // Método para obtener el número de series de un ejercicio
  int _obtenerSeriesDeEjercicio(dynamic ejercicio) {
    // Si el ejercicio tiene información de series configuradas
    if (ejercicio.series != null) {
      if (ejercicio.series is int) {
        return ejercicio.series;
      } else if (ejercicio.series is List) {
        return ejercicio.series.length;
      }
    }

    // Si el ejercicio tiene un campo "numSeries" o similar
    if (ejercicio.numSeries != null && ejercicio.numSeries is int) {
      return ejercicio.numSeries;
    }

    // Si no podemos determinar el número de series, devolver un valor predeterminado
    return 3; // Valor predeterminado común para series en entrenamientos
  }

  // Método para limpiar los datos
  void clearData() {
    exercisesPerDay.clear();
    setsPerDay.clear();
    update();
  }

  // Método para obtener datos de la semana actual vs la anterior
  Map<String, dynamic> getWeeklyComparison() {
    // Implementar lógica de comparación si es necesario
    return {
      'thisWeekExercises': _sumCurrentWeekStats(exercisesPerDay),
      'lastWeekExercises':
          0, // Implementar si tienes datos de semanas anteriores
      'thisWeekSets': _sumCurrentWeekStats(setsPerDay),
      'lastWeekSets': 0, // Implementar si tienes datos de semanas anteriores
    };
  }

  // Suma las estadísticas de la semana actual
  int _sumCurrentWeekStats(List<DailyStats> stats) {
    return stats.fold(0, (sum, item) => sum + item.value);
  }

  // Método para actualizar los datos desde Firebase
  Future<void> refreshData() async {
    clearData();
    await loadDataFromFirebase();
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
