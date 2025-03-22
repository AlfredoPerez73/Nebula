import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:nebula/src/models/exercises.model.dart';
import 'package:nebula/src/models/training.model.dart';
import 'package:nebula/src/services/training.services.dart';

class EntrenamientoController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  // Estado
  List<Entrenamiento> _entrenamientos = [];
  // Getter para acceder a los ejercicios del entrenamiento actual
  List<Ejercicio> get ejercicios => _entrenamientoActual?.ejercicios ?? [];
  Entrenamiento? _entrenamientoActual;
  bool _cargando = false;
  String? _error;

  // Getters
  List<Entrenamiento> get entrenamientos => _entrenamientos;
  Entrenamiento? get entrenamientoActual => _entrenamientoActual;
  bool get cargando => _cargando;
  String? get error => _error;
  bool get tieneError => _error != null;

  // Constructor
  EntrenamientoController() {
    cargarEntrenamientos();
  }

  // Cargar todos los entrenamientos del usuario
  Future<void> cargarEntrenamientos() async {
    _setEstadoCargando(true);
    try {
      _entrenamientos = await _firebaseService.obtenerEntrenamientosUsuario();
    } catch (e) {
      _error = "Error al cargar entrenamientos: ${e.toString()}";
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Crear un nuevo entrenamiento
  Future<String?> crearEntrenamiento(String nombre) async {
    _setEstadoCargando(true);
    try {
      String id = await _firebaseService.crearEntrenamiento(nombre);
      await cargarEntrenamientos(); // Recargar la lista
      _error = null;
      return id;
    } catch (e) {
      _error = "Error al crear entrenamiento: ${e.toString()}";
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
    } catch (e) {
      _error = "Error al cargar el entrenamiento: ${e.toString()}";
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Agregar un ejercicio al entrenamiento actual
  Future<void> agregarEjercicio(Ejercicio ejercicio) async {
    if (_entrenamientoActual == null) {
      _error = "No hay un entrenamiento seleccionado";
      return;
    }

    _setEstadoCargando(true);
    try {
      await _firebaseService.agregarEjercicioAEntrenamiento(
          _entrenamientoActual!.id, ejercicio);

      // Recargar el entrenamiento para obtener los cambios
      await cargarEntrenamiento(_entrenamientoActual!.id);
      _error = null;
    } catch (e) {
      _error = "Error al agregar ejercicio: ${e.toString()}";
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Eliminar un ejercicio del entrenamiento actual
  Future<void> eliminarEjercicio(String ejercicioId) async {
    if (_entrenamientoActual == null) {
      _error = "No hay un entrenamiento seleccionado";
      return;
    }

    _setEstadoCargando(true);
    try {
      await _firebaseService.eliminarEjercicioDeEntrenamiento(
          _entrenamientoActual!.id, ejercicioId);

      // Recargar el entrenamiento para reflejar los cambios
      await cargarEntrenamiento(_entrenamientoActual!.id);
      _error = null;
    } catch (e) {
      _error = "Error al eliminar ejercicio: ${e.toString()}";
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
      }
    } catch (e) {
      _error = "Error al eliminar entrenamiento: ${e.toString()}";
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Actualizar un ejercicio existente
  Future<void> actualizarEjercicio(Ejercicio ejercicio) async {
    if (_entrenamientoActual == null) {
      _error = "No hay un entrenamiento seleccionado";
      return;
    }

    _setEstadoCargando(true);
    try {
      await _firebaseService.actualizarEjercicioEnEntrenamiento(
          _entrenamientoActual!.id, ejercicio);

      // Recargar el entrenamiento para obtener los cambios
      await cargarEntrenamiento(_entrenamientoActual!.id);
      _error = null;
    } catch (e) {
      _error = "Error al actualizar ejercicio: ${e.toString()}";
    } finally {
      _setEstadoCargando(false);
    }
  }

  // Método auxiliar para actualizar el estado de carga
  void _setEstadoCargando(bool valor) {
    _cargando = valor;
  }

  // Limpiar errores
  void limpiarError() {
    _error = null;
  }

  void seleccionarEntrenamiento(String id) {
    try {
      // Find the training with the matching ID
      final entrenamientoEncontrado = _entrenamientos.firstWhere(
        (entrenamiento) => entrenamiento.id == id,
      );

      // If found, set it as the current training
      _entrenamientoActual = entrenamientoEncontrado;

      // Save the last selected training ID to persistent storage
      _firebaseService.guardarUltimoEntrenamientoSeleccionado(id);

      // Notify listeners about the change
    } catch (e) {
      // If no training with the given ID is found, select the first one if available
      if (_entrenamientos.isNotEmpty) {
        _entrenamientoActual = _entrenamientos.first;
        _firebaseService
            .guardarUltimoEntrenamientoSeleccionado(_entrenamientos.first.id);
      }
    }
  }
}
