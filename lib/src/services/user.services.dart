import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registro de usuario
  Future<Usuario?> registerWithEmail(
      String nombre,
      String email,
      String password,
      String nivelExperiencia,
      double peso,
      double altura,
      String objetivo) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        Usuario newUser = Usuario(
          uid: user.uid,
          nombre: nombre,
          email: email,
          nivelExperiencia: nivelExperiencia,
          peso: peso,
          altura: altura,
          objetivo: objetivo,
        );

        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(newUser.toMap());
          return newUser;
        } catch (firestoreError) {
          throw Exception("Error al guardar en Firestore: $firestoreError");
        }
      } else {
        throw Exception("Firebase Auth devolvió usuario nulo");
      }
    } catch (e) {
      throw e;
    }
  }

  // Inicio de sesión
  Future<Usuario?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        return await getUserData(user.uid);
      }
    } catch (e) {
      print("Error en el inicio de sesión: $e");
    }
    return null;
  }

  // Obtener datos del usuario
  Future<Usuario?> getUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return Usuario.fromFirestore(
            userDoc.data() as Map<String, dynamic>, uid);
      }
    } catch (e) {
      print("Error al obtener datos del usuario: $e");
    }
    return null;
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

// Método para actualizar el perfil del usuario en Firestore
  Future<void> updateUserProfile(
    String uid,
    String nombre,
    String email,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'nombre': nombre,
        'email': email,
      });
    } catch (e) {
      print("Error al actualizar el perfil del usuario: $e");
      throw Exception("No se pudo actualizar el perfil");
    }
  }

  Future<void> updateUserProfileSkills(
    String uid,
    String nivelExperiencia,
    double peso,
    double altura,
    String objetivo,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'nivelExperiencia': nivelExperiencia,
        'peso': peso,
        'altura': altura,
        'objetivo': objetivo,
      });
    } catch (e) {
      print("Error al actualizar el perfil del usuario: $e");
      throw Exception("No se pudo actualizar el perfil");
    }
  }
}
