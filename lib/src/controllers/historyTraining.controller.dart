import 'package:get/get.dart';
import 'package:nebula/src/models/historyExercises.model.dart';
import 'package:nebula/src/models/historyTraining.model.dart';
import 'package:nebula/src/models/exercises.model.dart';
import 'package:nebula/src/models/training.model.dart';
import 'package:nebula/src/services/historyTraining.services.dart';
import 'package:nebula/src/controllers/training.controller.dart';
import 'package:intl/intl.dart';

class HistoryEntrenamientoController extends GetxController {
  final FirebaseService _historyService = FirebaseService();
  final EntrenamientoController _entrenamientoController = Get.find<EntrenamientoController>();

  // Estado
  RxList<HistoryEntrenamiento> _entrenamientos = <HistoryEntrenamiento>[].obs;
  Rx<HistoryEntrenamiento?> _entrenamientoActual = Rx<HistoryEntrenamiento?>(null);
  RxBool _cargando = false.obs;
  RxString _error = ''.obs;
  RxString _searchQuery = ''.obs;
  RxString _selectedTimeFrame = 'Todos'.obs;
  RxString _selectedType = 'Todos'.obs;

  // Getters observables
  List<HistoryEntrenamiento> get entrenamientos => _entrenamientos;
  HistoryEntrenamiento? get entrenamientoActual => _entrenamientoActual.value;
  List<HistoryEjercicio> get ejercicios => _entrenamientoActual.value?.ejercicios ?? [];
  bool get cargando => _cargando.value;
  String get error => _error.value;
  bool get tieneError => _error.value.isNotEmpty;
  String get searchQuery => _searchQuery.value;
  String get selectedTimeFrame => _selectedTimeFrame.value;
  String get selectedType => _selectedType.value;

  // Días de la semana para filtrar
  RxString diaSeleccionado = 'Lunes'.obs;

  // Período de filtro
  static final List<String> timeFrames = ["Todos", "Esta semana", "Este mes", "Este año"];
  
  // Tipos de entrenamiento para filtrar
  static final List<String> workoutTypes = ["Todos", "Fuerza", "Cardio", "Flexibilidad", "Personalizado"];

  // Estadísticas
  RxInt _entrenamientosMes = 0.obs;
  RxDouble _cumplimientoMeta = 0.0.obs;
  RxDouble _tiempoTotal = 0.0.obs;

  int get entrenamientosMes => _entrenamientosMes.value;
  double get cumplimientoMeta => _cumplimientoMeta.value;
  double get tiempoTotal => _tiempoTotal.value;

  @override
  void onInit() {
    super.onInit();
    // Inicializar y cargar datos
    cargarEntrenamientos();
    
    // Sincronizar con los entrenamientos activos al inicio
    sincronizarConEntrenamientosActivos();
    
    // Configurar actualización periódica (cada 30 segundos)
    Future.delayed(const Duration(seconds: 30), () {
      if (Get.isRegistered<HistoryEntrenamientoController>()) {
        sincronizarConEntrenamientosActivos();
      }
    });
  }

  // Métodos para filtros
  void seleccionarDia(String dia) {
    diaSeleccionado.value = dia;
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void setSelectedTimeFrame(String timeFrame) {
    _selectedTimeFrame.value = timeFrame;
  }

  void setSelectedType(String type) {
    _selectedType.value = type;
  }

  // Método para obtener ejercicios por el día seleccionado
  List<HistoryEjercicio> get ejerciciosPorDia {
    return ejercicios
        .where((e) => e.dia.toLowerCase() == diaSeleccionado.value.toLowerCase())
        .toList();
  }

  // Método para filtrar entrenamientos según el timeframe seleccionado
  List<HistoryEntrenamiento> get entrenamientosFiltrados {
    // Primero filtramos por búsqueda
    var filtrados = _entrenamientos.where((entrenamiento) {
      if (searchQuery.isEmpty) return true;
      return entrenamiento.nombre.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // Luego filtramos por período
    if (_selectedTimeFrame.value != 'Todos') {
      DateTime fechaLimite = DateTime.now();
      
      if (_selectedTimeFrame.value == 'Esta semana') {
        // Inicio de la semana (lunes)
        int weekday = fechaLimite.weekday;
        fechaLimite = fechaLimite.subtract(Duration(days: weekday - 1));
        fechaLimite = DateTime(fechaLimite.year, fechaLimite.month, fechaLimite.day);
      } else if (_selectedTimeFrame.value == 'Este mes') {
        // Inicio del mes
        fechaLimite = DateTime(fechaLimite.year, fechaLimite.month, 1);
      } else if (_selectedTimeFrame.value == 'Este año') {
        // Inicio del año
        fechaLimite = DateTime(fechaLimite.year, 1, 1);
      }
      
      // Aquí necesitaríamos una fecha en el modelo, por ahora lo dejamos preparado
      // filtrados = filtrados.where((e) => e.fecha.isAfter(fechaLimite)).toList();
    }

    // Finalmente filtramos por tipo (aquí necesitaríamos un campo de tipo en el modelo)
    if (_selectedType.value != 'Todos') {
      // filtrados = filtrados.where((e) => e.tipo == _selectedType.value).toList();
    }

    return filtrados;
  }

  // Cargar todos los entrenamientos del usuario
// En historyTraining.controller.dart
Future<void> cargarEntrenamientos() async {
  _setEstadoCargando(true);
  try {
    // Primero sincronizar con entrenamientos activos
    await _historyService.sincronizarConEntrenamientosActivos();
    
    // Luego cargar los entrenamientos del historial
    final entrenamientos = await _historyService.obtenerEntrenamientosUsuario();
    _entrenamientos.value = entrenamientos;
    
    // Calcular estadísticas
    _calcularEstadisticas();
    
    _error.value = '';
  } catch (e) {
    _error.value = "Error al cargar entrenamientos: ${e.toString()}";
  } finally {
    _setEstadoCargando(false);
  }
}

  // Calcular estadísticas basadas en los entrenamientos cargados
  void _calcularEstadisticas() {
    // Contar entrenamientos este mes
    final ahora = DateTime.now();
    final inicioDeMes = DateTime(ahora.year, ahora.month, 1);
    
    // Para demo, simplemente usamos el total
    _entrenamientosMes.value = _entrenamientos.length;
    
    // Para cumplimiento de meta y tiempo, usamos valores de demostración
    // En una implementación real, estos valores vendrían de los datos reales
    _cumplimientoMeta.value = 67.0; // 67%
    _tiempoTotal.value = 4.5; // 4.5 horas
  }

  // Cargar un entrenamiento específico con sus ejercicios
  Future<void> cargarEntrenamiento(String entrenamientoId) async {
    _setEstadoCargando(true);
    try {
      _entrenamientoActual.value = await _historyService.obtenerEntrenamiento(entrenamientoId);
      _error.value = '';
    } catch (e) {
      _error.value = "Error al cargar el entrenamiento: ${e.toString()}";
    } finally {
      _setEstadoCargando(false);
    }
  }

// En historyTraining.controller.dart
Future<void> crearEntrenamientoExplicito(String id, String nombre, String usuarioId) async {
  try {
    await _historyService.crearEntrenamientoConId(id, nombre, usuarioId);
    await cargarEntrenamientos();
  } catch (e) {
    print("Error creando entrenamiento en historial: $e");
  }
}
  
  // Método para agregar explícitamente un ejercicio al historial
  Future<void> agregarEjercicioExplicito(String entrenamientoId, HistoryEjercicio ejercicio) async {
    try {
      // Verificar si existe el entrenamiento en el historial
      bool existe = await _historyService.existeEntrenamiento(entrenamientoId);
      
      // Si no existe, simplemente regresamos (no podemos agregar un ejercicio a un entrenamiento que no existe)
      if (!existe) {
        print("Entrenamiento no encontrado en el historial: $entrenamientoId");
        return;
      }
      
      // Agregamos el ejercicio
      await _historyService.agregarEjercicioAEntrenamiento(entrenamientoId, ejercicio);
      
      // Recargamos los entrenamientos para reflejar los cambios
      await cargarEntrenamientos();
    } catch (e) {
      print("Error al agregar ejercicio al historial: ${e.toString()}");
    }
  }                          
  // Método para sincronizar con entrenamientos activos
  Future<void> sincronizarConEntrenamientosActivos() async {
    try {
      // Obtenemos todos los entrenamientos activos de manera segura
      List<Entrenamiento> entrenamientosActivos = [];
      try {
        entrenamientosActivos = _entrenamientoController.entrenamientos;
      } catch (e) {
        print("Error al obtener entrenamientos activos: ${e.toString()}");
        return;
      }
      
      // Para cada entrenamiento activo, verificamos si existe en el historial
      for (final entrenamientoActivo in entrenamientosActivos) {
        bool existe = await _historyService.existeEntrenamiento(entrenamientoActivo.id);
        
        // Si no existe, lo creamos en el historial
        if (!existe) {
          await _historyService.crearEntrenamientoConId(
            entrenamientoActivo.id,
            entrenamientoActivo.nombre,
            entrenamientoActivo.usuarioId
          );
        }
        
        // Ahora sincronizamos los ejercicios
        await _sincronizarEjercicios(entrenamientoActivo.id, entrenamientoActivo.ejercicios);
      }
      
      // Recargamos los entrenamientos del historial
      await cargarEntrenamientos();
      
    } catch (e) {
      print("Error al sincronizar entrenamientos: ${e.toString()}");
    }
  }
  
  // Método auxiliar para sincronizar ejercicios
  Future<void> _sincronizarEjercicios(String entrenamientoId, List<Ejercicio> ejercicios) async {
    try {
      // Obtenemos el entrenamiento del historial para comparar ejercicios
      final historialEntrenamiento = await _historyService.obtenerEntrenamiento(entrenamientoId);
      
      if (historialEntrenamiento == null) return;
      
      // Mapa para buscar ejercicios rápidamente en el historial
      Map<String, HistoryEjercicio> ejerciciosHistorial = {};
      for (var ejercicio in historialEntrenamiento.ejercicios) {
        ejerciciosHistorial[ejercicio.id] = ejercicio;
      }
      
      // Para cada ejercicio activo, verificamos si existe en el historial
      for (var ejercicioActivo in ejercicios) {
        // Si no existe en el historial, lo agregamos
        if (!ejerciciosHistorial.containsKey(ejercicioActivo.id)) {
          // Convertimos el ejercicio activo a HistoryEjercicio
          final historialEjercicio = HistoryEjercicio(
            id: ejercicioActivo.id,
            nombre: ejercicioActivo.nombre,
            dia: ejercicioActivo.dia,
            series: ejercicioActivo.series,
            repeticiones: ejercicioActivo.repeticiones,
          );
          
          // Agregamos al historial
          await _historyService.agregarEjercicioAEntrenamiento(
            entrenamientoId,
            historialEjercicio
          );
        }
      }
    } catch (e) {
      print("Error al sincronizar ejercicios: ${e.toString()}");
    }
  }

  // Método auxiliar para actualizar el estado de carga
  void _setEstadoCargando(bool valor) {
    _cargando.value = valor;
  }

  // Limpiar errores
  void limpiarError() {
    _error.value = '';
  }
  
  // Método para actualización manual desde otros controladores
  void actualizar() {
    sincronizarConEntrenamientosActivos();
  }
}