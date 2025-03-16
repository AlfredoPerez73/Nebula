import '../views/pages/auth/LoginPage.dart';
import 'package:get_storage/get_storage.dart';
import '../views/home.dart';
import '../services/user.services.dart';
import '../models/user.model.dart';
import 'package:get/get.dart';

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
    await _firebaseService.signOut();
    await _clearCredentials();
    userModel.value = null;
    Get.offAll(() => LoginPage());
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
        nivelExperiencia: userModel.value!.nombre,
        peso: userModel.value!.peso,
        altura: userModel.value!.altura,
        objetivo: userModel.value!.objetivo,
      );

      // Actualizar el estado de userModel con la nueva instancia
      userModel.value = updatedUser;
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

      // Llamar al método del servicio para actualizar los datos en Firestore
      await _firebaseService.updateUserProfileSkills(
          uid, nivelExperiencia, peso, altura, objetivo);

      // Crear una nueva instancia de UserModel con los datos actualizados
      Usuario updatedUser = Usuario(
        uid: userModel.value!.uid,
        nombre: userModel.value!.nombre,
        email: userModel.value!.email,
        nivelExperiencia: nivelExperiencia,
        peso: peso,
        altura: altura,
        objetivo: objetivo,
      );

      // Actualizar el estado de userModel con la nueva instancia
      userModel.value = updatedUser;
    } catch (e) {
      Get.snackbar("Error", "No se pudieron actualizar los datos del perfil");
    }
  }
}
