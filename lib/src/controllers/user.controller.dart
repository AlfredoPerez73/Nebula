import '../views/pages/auth/login_page.dart';
import 'package:get_storage/get_storage.dart';
import '../views/home.dart';
import '../services/user.services.dart';
import '../models/user.model.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var isLoading = false.obs;
  var userModel = Rxn<Usuario>(); // Observa el estado del UserModel
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _autoLogin(); // Intentar login automático
  }

  // Registrar usuario
  Future<void> register(
      String nombre,
      String email,
      String password,
      String nivelExperiencia,
      double peso,
      double altura,
      String objetivo) async {
    try {
      isLoading.value = true;

      Usuario? newUser = await _firebaseService.registerWithEmail(
          nombre, email, password, nivelExperiencia, peso, altura, objetivo);

      if (newUser != null) {
        userModel.value = newUser;
        await _saveCredentials(email, password);
        Get.offAll(() => HomeScreen());
      } else {
        // Mensaje más específico
        Get.snackbar("Error",
            "No se pudo registrar el usuario: La función registerWithEmail devolvió null",
            duration: Duration(seconds: 5));
      }
    } catch (e) {
      // Mostrar el error específico
      Get.snackbar(
          "Error", "Ocurrió un error durante el registro: ${e.toString()}",
          duration: Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

  // Iniciar sesión
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      Usuario? loggedInUser =
          await _firebaseService.loginWithEmail(email, password);
      if (loggedInUser != null) {
        userModel.value = loggedInUser;
        await _saveCredentials(email, password);
        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar("Error", "No se pudo iniciar sesión");
      }
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error durante el inicio de sesión");
    } finally {
      isLoading.value = false;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      // Primero navega a la página de login
      Get.off(() => LoginPage());

      // Luego, después de que la navegación se ha completado, realiza la limpieza
      await Future.delayed(Duration(milliseconds: 100));
      await _firebaseService.signOut();
      await _clearCredentials();
      userModel.value = null;
    } catch (e) {
      Get.snackbar("Error", "Error al cerrar sesión: ${e.toString()}");
    }
  }

  // Guardar credenciales
  Future<void> _saveCredentials(String email, String password) async {
    storage.write('email', email);
    storage.write('password', password);
  }

  // Intentar login automático
  Future<void> _autoLogin() async {
    try {
      String? email = storage.read('email');
      String? password = storage.read('password');
      if (email != null && password != null) {
        await login(email, password); // Auto login con credenciales guardadas
      }
    } catch (e) {
      Get.snackbar(
          "Error", "Ocurrió un error durante el inicio de sesión automático");
    }
  }

  // Limpiar credenciales guardadas
  Future<void> _clearCredentials() async {
    storage.remove('email');
    storage.remove('password');
  }

  // Método para actualizar los datos del perfil del usuario
  Future<void> updateUserProfile(
    String nombre,
    String email,
  ) async {
    try {
      String uid = userModel.value!.uid;

      // Llamar al método del servicio para actualizar los datos en Firestore
      await _firebaseService.updateUserProfile(uid, nombre, email);

      // Crear una nueva instancia de UserModel con los datos actualizados
      Usuario updatedUser = Usuario(
        uid: userModel.value!.uid,
        nombre: nombre,
        email: email,
        nivelExperiencia: userModel.value!.nivelExperiencia,
        peso: userModel.value!.peso,
        altura: userModel.value!.altura,
        objetivo: userModel.value!.objetivo,
      );

      // Actualizar el estado de userModel con la nueva instancia
      userModel.value = updatedUser;

      // NUEVO: Forzar actualización de UI
      update();

      developer.log("Perfil actualizado: $nombre, $email",
          name: "AuthController");
    } catch (e) {
      Get.snackbar("Error", "No se pudieron actualizar los datos del perfil");
    }
  }

  Future<void> updateUserProfileSkills(
    String nivelExperiencia,
    double peso,
    double altura,
    String objetivo,
  ) async {
    try {
      String uid = userModel.value!.uid;

      // Log para debugging
      developer.log(
          "Actualizando perfil - Peso anterior: ${userModel.value?.peso}, Nuevo peso: $peso",
          name: "AuthController");

      // Llamar al método del servicio para actualizar los datos en Firestore
      await _firebaseService.updateUserProfileSkills(
          uid, nivelExperiencia, peso, altura, objetivo);

      // MODIFICACIÓN: Crear una copia del usuario actual para preservar otros campos
      final currentUser = userModel.value!;
      Usuario updatedUser = Usuario(
        uid: currentUser.uid,
        nombre: currentUser.nombre,
        email: currentUser.email,
        nivelExperiencia: nivelExperiencia,
        peso: peso,
        altura: altura,
        objetivo: objetivo,
      );

      // Actualizar el estado de userModel con la nueva instancia
      userModel.value = updatedUser;

      // NUEVO: Forzar actualización de UI
      update();

      // Log para confirmar actualización
      developer.log("Perfil actualizado - Nuevo peso: ${userModel.value?.peso}",
          name: "AuthController");
    } catch (e) {
      Get.snackbar("Error", "No se pudieron actualizar los datos del perfil");
      developer.log("Error al actualizar perfil: $e", name: "AuthController");
    }
  }

  // NUEVO: Método para actualizar específicamente el peso
  Future<void> updateUserWeight(double newWeight) async {
    try {
      if (userModel.value == null) {
        throw Exception("No hay usuario logueado");
      }

      String uid = userModel.value!.uid;

      // Log para debugging
      developer.log(
          "Actualizando peso - Anterior: ${userModel.value?.peso}, Nuevo: $newWeight",
          name: "AuthController");

      // Actualizar solo el peso en Firestore
      await _firebaseService.updateUserWeight(uid, newWeight);

      // Crear una copia del usuario actual con el nuevo peso
      final currentUser = userModel.value!;
      Usuario updatedUser = Usuario(
        uid: currentUser.uid,
        nombre: currentUser.nombre,
        email: currentUser.email,
        nivelExperiencia: currentUser.nivelExperiencia,
        peso: newWeight, // Nuevo peso
        altura: currentUser.altura,
        objetivo: currentUser.objetivo,
      );

      // Actualizar el modelo
      userModel.value = updatedUser;

      // Forzar actualización de UI
      update();

      developer.log("Peso actualizado a: $newWeight", name: "AuthController");
    } catch (e) {
      Get.snackbar("Error", "No se pudo actualizar el peso: ${e.toString()}");
      developer.log("Error al actualizar peso: $e", name: "AuthController");
    }
  }

  // NUEVO: Método para refrescar datos del usuario desde Firebase
  Future<void> refreshUserData() async {
    try {
      if (userModel.value == null) {
        return;
      }

      String uid = userModel.value!.uid;
      developer.log("Refrescando datos de usuario: $uid",
          name: "AuthController");

      // Obtener datos actualizados desde Firebase
      Usuario? updatedUser = await _firebaseService.getUserData(uid);

      if (updatedUser != null) {
        // Actualizar el modelo
        userModel.value = updatedUser;

        // Forzar actualización de UI
        update();

        developer.log(
            "Datos de usuario actualizados - Peso: ${updatedUser.peso}, Altura: ${updatedUser.altura}",
            name: "AuthController");
      }
    } catch (e) {
      developer.log("Error al refrescar datos: $e", name: "AuthController");
    }
  }

  // NUEVO: Método para forzar notificación a todos los widgets
  void notifyModelChanged() {
    update();
    developer.log("Notificación forzada de cambio de modelo",
        name: "AuthController");
  }
}
