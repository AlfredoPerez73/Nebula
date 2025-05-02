import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nebula/src/models/historyExercises.model.dart';
import 'package:nebula/src/models/historyTraining.model.dart';
import 'package:nebula/src/models/exercises.model.dart';
import 'package:nebula/src/models/training.model.dart';
import 'package:nebula/src/services/historyTraining.services.dart';
import 'package:nebula/src/controllers/training.controller.dart';

class HistoryEntrenamientoController extends GetxController {
  final FirebaseService _historyService = FirebaseService();
  final EntrenamientoController _entrenamientoController =
      Get.find<EntrenamientoController>();

  final RxList<HistoryEntrenamiento> _entrenamientos =
      <HistoryEntrenamiento>[].obs;
  final Rx<HistoryEntrenamiento?> _entrenamientoActual =
      Rx<HistoryEntrenamiento?>(null);
  final RxBool _cargando = false.obs;
  final RxString _error = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _selectedTimeFrame = 'Todos'.obs;
  final RxString _selectedType = 'Todos'.obs;

  List<HistoryEntrenamiento> get entrenamientos => _entrenamientos;
  HistoryEntrenamiento? get entrenamientoActual => _entrenamientoActual.value;
  List<HistoryEjercicio> get ejercicios =>
      _entrenamientoActual.value?.ejercicios ?? [];
  bool get cargando => _cargando.value;
  String get error => _error.value;
  bool get tieneError => _error.value.isNotEmpty;
  String get searchQuery => _searchQuery.value;
  String get selectedTimeFrame => _selectedTimeFrame.value;
  String get selectedType => _selectedType.value;

  RxString diaSeleccionado = 'Lunes'.obs;

  static final List<String> timeFrames = [
    "Todos",
    "Esta semana",
    "Este mes",
    "Este año"
  ];

  static final List<String> workoutTypes = [
    "Todos",
    "Fuerza",
    "Cardio",
    "Flexibilidad",
    "Personalizado"
  ];

  final RxInt _entrenamientosMes = 0.obs;
  final RxDouble _cumplimientoMeta = 0.0.obs;
  final RxDouble _tiempoTotal = 0.0.obs;

  int get entrenamientosMes => _entrenamientosMes.value;
  double get cumplimientoMeta => _cumplimientoMeta.value;
  double get tiempoTotal => _tiempoTotal.value;

  @override
  void onInit() {
    super.onInit();
    cargarEntrenamientos();

    sincronizarConEntrenamientosActivos();

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

  List<HistoryEjercicio> get ejerciciosPorDia {
    return ejercicios
        .where(
            (e) => e.dia.toLowerCase() == diaSeleccionado.value.toLowerCase())
        .toList();
  }

  List<HistoryEntrenamiento> get entrenamientosFiltrados {
    var filtrados = _entrenamientos.where((entrenamiento) {
      if (searchQuery.isEmpty) return true;
      return entrenamiento.nombre
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    if (_selectedTimeFrame.value != 'Todos') {
      DateTime fechaLimite = DateTime.now();

      if (_selectedTimeFrame.value == 'Esta semana') {
        int weekday = fechaLimite.weekday;
        fechaLimite = fechaLimite.subtract(Duration(days: weekday - 1));
        fechaLimite =
            DateTime(fechaLimite.year, fechaLimite.month, fechaLimite.day);
      } else if (_selectedTimeFrame.value == 'Este mes') {
        fechaLimite = DateTime(fechaLimite.year, fechaLimite.month, 1);
      } else if (_selectedTimeFrame.value == 'Este año') {
        fechaLimite = DateTime(fechaLimite.year, 1, 1);
      }
    }

    if (_selectedType.value != 'Todos') {}

    return filtrados;
  }

  Future<void> cargarEntrenamientos() async {
    _setEstadoCargando(true);
    try {
      await _historyService.sincronizarConEntrenamientosActivos();
      final entrenamientos =
          await _historyService.obtenerEntrenamientosUsuario();
      _entrenamientos.value = entrenamientos;

      _calcularEstadisticas();

      _error.value = '';
    } catch (e) {
      _error.value = "Error al cargar entrenamientos: ${e.toString()}";
    } finally {
      _setEstadoCargando(false);
    }
  }

  void _calcularEstadisticas() {
    _entrenamientosMes.value = _entrenamientos.length;
    _cumplimientoMeta.value = 67.0;
    _tiempoTotal.value = 4.5;
  }

  Future<void> cargarEntrenamiento(String entrenamientoId) async {
    _setEstadoCargando(true);
    try {
      _entrenamientoActual.value =
          await _historyService.obtenerEntrenamiento(entrenamientoId);
      _error.value = '';
    } catch (e) {
      _error.value = "Error al cargar el entrenamiento: ${e.toString()}";
    } finally {
      _setEstadoCargando(false);
    }
  }

  Future<void> crearEntrenamientoExplicito(
      String id, String nombre, String usuarioId) async {
    try {
      await _historyService.crearEntrenamientoConId(id, nombre, usuarioId);
      await cargarEntrenamientos();
    } catch (e) {
      debugPrint("Error creando entrenamiento en historial: $e");
    }
  }

  Future<void> agregarEjercicioExplicito(
      String entrenamientoId, HistoryEjercicio ejercicio) async {
    try {
      bool existe = await _historyService.existeEntrenamiento(entrenamientoId);

      if (!existe) {
        debugPrint(
            "Entrenamiento no encontrado en el historial: $entrenamientoId");
        return;
      }

      await _historyService.agregarEjercicioAEntrenamiento(
          entrenamientoId, ejercicio);

      await cargarEntrenamientos();
    } catch (e) {
      debugPrint("Error al agregar ejercicio al historial: ${e.toString()}");
    }
  }

  Future<void> sincronizarConEntrenamientosActivos() async {
    try {
      List<Entrenamiento> entrenamientosActivos = [];
      try {
        entrenamientosActivos = _entrenamientoController.entrenamientos;
      } catch (e) {
        debugPrint("Error al obtener entrenamientos activos: ${e.toString()}");
        return;
      }

      for (final entrenamientoActivo in entrenamientosActivos) {
        bool existe =
            await _historyService.existeEntrenamiento(entrenamientoActivo.id);

        if (!existe) {
          await _historyService.crearEntrenamientoConId(entrenamientoActivo.id,
              entrenamientoActivo.nombre, entrenamientoActivo.usuarioId);
        }

        await _sincronizarEjercicios(
            entrenamientoActivo.id, entrenamientoActivo.ejercicios);
      }

      await cargarEntrenamientos();
    } catch (e) {
      debugPrint("Error al sincronizar entrenamientos: ${e.toString()}");
    }
  }

  Future<void> _sincronizarEjercicios(
      String entrenamientoId, List<Ejercicio> ejercicios) async {
    try {
      final historialEntrenamiento =
          await _historyService.obtenerEntrenamiento(entrenamientoId);

      if (historialEntrenamiento == null) return;

      Map<String, HistoryEjercicio> ejerciciosHistorial = {};
      for (var ejercicio in historialEntrenamiento.ejercicios) {
        ejerciciosHistorial[ejercicio.id] = ejercicio;
      }

      for (var ejercicioActivo in ejercicios) {
        if (!ejerciciosHistorial.containsKey(ejercicioActivo.id)) {
          final historialEjercicio = HistoryEjercicio(
            id: ejercicioActivo.id,
            nombre: ejercicioActivo.nombre,
            dia: ejercicioActivo.dia,
            series: ejercicioActivo.series,
            repeticiones: ejercicioActivo.repeticiones,
          );

          // Agregamos al historial
          await _historyService.agregarEjercicioAEntrenamiento(
              entrenamientoId, historialEjercicio);
        }
      }
    } catch (e) {
      debugPrint("Error al sincronizar ejercicios: ${e.toString()}");
    }
  }

  void _setEstadoCargando(bool valor) {
    _cargando.value = valor;
  }

  void limpiarError() {
    _error.value = '';
  }

  void actualizar() {
    sincronizarConEntrenamientosActivos();
  }
}
