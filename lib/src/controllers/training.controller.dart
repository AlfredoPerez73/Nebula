import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nebula/src/models/exercises.model.dart';
import 'package:nebula/src/models/training.model.dart';
import 'package:nebula/src/services/training.services.dart';
import 'package:nebula/src/controllers/historyTraining.controller.dart';

class EntrenamientoController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  // Estado
  List<Entrenamiento> _entrenamientos = [];
  Entrenamiento? _entrenamientoActual;
  bool _cargando = false;
  String? _error;

  // Getters
  List<Entrenamiento> get entrenamientos => _entrenamientos;
  Entrenamiento? get entrenamientoActual => _entrenamientoActual;
  List<Ejercicio> get ejercicios => _entrenamientoActual?.ejercicios ?? [];
  bool get cargando => _cargando;
  String? get error => _error;
  bool get tieneError => _error != null;

  // Constructor
  @override
  void onInit() {
    super.onInit();
    cargarEntrenamientos();
  }

  @override
  void onClose() {
    // Limpiar recursos y estados cuando se navega fuera de la página
    super.onClose();
  }

  String diaSeleccionado = 'Lunes';

  // ... (resto del controlador)

  void seleccionarDia(String dia) {
    diaSeleccionado = dia;
    update(); // Notifica a los widgets que dependen de este controlador
  }

  // Método para obtener ejercicios por el día seleccionado
  List<Ejercicio> get ejerciciosPorDia {
    return ejercicios
        .where((e) => e.dia.toLowerCase() == diaSeleccionado.toLowerCase())
        .toList();
  }

  // Cargar todos los entrenamientos del usuario
  Future<void> cargarEntrenamientos() async {
    _setEstadoCargando(true);
    try {
      _entrenamientos = await _firebaseService.obtenerEntrenamientosUsuario();
      update(); // Notificar a los listeners
    } catch (e) {
      _error = "Error al cargar entrenamientos: ${e.toString()}";
      update();
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Crear un nuevo entrenamiento
  Future<String?> crearEntrenamiento(String nombre) async {
    _setEstadoCargando(true);
    try {
      String id = await _firebaseService.crearEntrenamiento(nombre);

      // Ahora intentamos sincronizar con el historial
      try {
        if (Get.isRegistered<HistoryEntrenamientoController>()) {
          final historyController = Get.find<HistoryEntrenamientoController>();

          // Usamos cargarEntrenamientos en lugar de llamar a crearEntrenamientoExplicito
          await historyController.cargarEntrenamientos();
        }
      } catch (e) {
        debugPrint("Error sincronizando con historial: $e");
      }

      await cargarEntrenamientos();
      _error = null;
      update();

      return id;
    } catch (e) {
      _error = "Error al crear entrenamiento: ${e.toString()}";
      update();
      return null;
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Cargar un entrenamiento específico con sus ejercicios
  Future<void> cargarEntrenamiento(String entrenamientoId) async {
    _setEstadoCargando(true);
    try {
      _entrenamientoActual =
          await _firebaseService.obtenerEntrenamiento(entrenamientoId);
      _error = null;
      update();
    } catch (e) {
      _error = "Error al cargar el entrenamiento: ${e.toString()}";
      update();
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Agregar un ejercicio al entrenamiento actual
// Agregar un ejercicio al entrenamiento actual
  Future<void> agregarEjercicio(Ejercicio ejercicio) async {
    if (_entrenamientoActual == null) {
      _error = "No hay un entrenamiento seleccionado";
      update();
      return;
    }

    _setEstadoCargando(true);
    try {
      // Primero, agregar el ejercicio al entrenamiento actual
      await _firebaseService.agregarEjercicioAEntrenamiento(
          _entrenamientoActual!.id, ejercicio);

      // Luego, intentar sincronizar con el historial
      try {
        if (Get.isRegistered<HistoryEntrenamientoController>()) {
          final historyController = Get.find<HistoryEntrenamientoController>();
          // Solo actualizar el historial, sin tratar de usar métodos específicos
          await historyController.cargarEntrenamientos();
        }
      } catch (e) {
        debugPrint("Error sincronizando con historial: $e");
      }

      // Recargar el entrenamiento para obtener los cambios
      await cargarEntrenamiento(_entrenamientoActual!.id);
      _error = null;
      update();
    } catch (e) {
      _error = "Error al agregar ejercicio: ${e.toString()}";
      update();
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Eliminar un ejercicio del entrenamiento actual
  Future<void> eliminarEjercicio(String ejercicioId) async {
    if (_entrenamientoActual == null) {
      _error = "No hay un entrenamiento seleccionado";
      update();
      return;
    }

    _setEstadoCargando(true);
    try {
      await _firebaseService.eliminarEjercicioDeEntrenamiento(
          _entrenamientoActual!.id, ejercicioId);

      // Recargar el entrenamiento para reflejar los cambios
      await cargarEntrenamiento(_entrenamientoActual!.id);
      _error = null;
      update();
    } catch (e) {
      _error = "Error al eliminar ejercicio: ${e.toString()}";
      update();
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Eliminar un entrenamiento completo
  Future<void> eliminarEntrenamiento(String entrenamientoId) async {
    _setEstadoCargando(true);
    try {
      // Primero obtener todos los ejercicios del entrenamiento
      Entrenamiento? entrenamiento =
          await _firebaseService.obtenerEntrenamiento(entrenamientoId);

      if (entrenamiento != null) {
        // Eliminar cada ejercicio
        for (var ejercicio in entrenamiento.ejercicios) {
          await _firebaseService.eliminarEjercicioDeEntrenamiento(
              entrenamientoId, ejercicio.id);
        }

        // Ahora eliminar el documento del entrenamiento
        await _firebaseService.eliminarEntrenamiento(entrenamientoId);

        // Si el entrenamiento eliminado era el actual, limpiarlo
        if (_entrenamientoActual?.id == entrenamientoId) {
          _entrenamientoActual = null;
        }

        // Recargar la lista de entrenamientos
        await cargarEntrenamientos();
        _error = null;
        update();
      }
    } catch (e) {
      _error = "Error al eliminar entrenamiento: ${e.toString()}";
      update();
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Actualizar un ejercicio existente
  Future<void> actualizarEjercicio(Ejercicio ejercicio) async {
    if (_entrenamientoActual == null) {
      _error = "No hay un entrenamiento seleccionado";
      update();
      return;
    }

    _setEstadoCargando(true);
    try {
      await _firebaseService.actualizarEjercicioEnEntrenamiento(
          _entrenamientoActual!.id, ejercicio);

      // Recargar el entrenamiento para obtener los cambios
      await cargarEntrenamiento(_entrenamientoActual!.id);
      _error = null;
      update();
    } catch (e) {
      _error = "Error al actualizar ejercicio: ${e.toString()}";
      update();
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Método auxiliar para actualizar el estado de carga
  void _setEstadoCargando(bool valor) {
    _cargando = valor;
    update();
  }

  // Limpiar errores
  void limpiarError() {
    _error = null;
    update();
  }

  void seleccionarEntrenamiento(String id) async {
    // Check if it's the same training already selected
    if (_entrenamientoActual != null && _entrenamientoActual!.id == id) {
      // Already selected - no need to do anything
      return;
    }

    try {
      // Set loading state while we fetch the training details
      _setEstadoCargando(true);

      // Find the training with the matching ID
      final entrenamientoEncontrado = _entrenamientos.firstWhere(
        (entrenamiento) => entrenamiento.id == id,
      );

      // If found, set it as the current training
      _entrenamientoActual = entrenamientoEncontrado;

      // Load the complete training data with exercises
      await cargarEntrenamiento(id);

      // Save the last selected training ID to persistent storage
      _firebaseService.guardarUltimoEntrenamientoSeleccionado(id);
    } catch (e) {
      // If no training with the given ID is found, select the first one if available
      if (_entrenamientos.isNotEmpty) {
        _entrenamientoActual = _entrenamientos.first;
        await cargarEntrenamiento(_entrenamientos.first.id);
        _firebaseService
            .guardarUltimoEntrenamientoSeleccionado(_entrenamientos.first.id);
      }
    } finally {
      _setEstadoCargando(false);
      update(); // Ensure UI is updated
    }
  }
}
