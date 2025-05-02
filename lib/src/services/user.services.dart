import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user.model.dart';
import 'dart:developer' as developer;

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
      throw Exception("Firebase Auth devolvió usuario nulo");
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
      debugPrint("Error en el inicio de sesión: $e");
    }
    return null;
  }

  // Obtener datos del usuario - MEJORADO CON LOGS
  Future<Usuario?> getUserData(String uid) async {
    try {
      developer.log("Obteniendo datos de usuario: $uid",
          name: "FirebaseService");

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Log para verificar datos
        developer.log(
            "Datos obtenidos - Peso: ${userData['peso']}, Altura: ${userData['altura']}",
            name: "FirebaseService");

        return Usuario.fromFirestore(userData, uid);
      } else {
        developer.log("El documento de usuario no existe",
            name: "FirebaseService");
      }
    } catch (e) {
      developer.log("Error al obtener datos del usuario: $e",
          name: "FirebaseService");
    }
    return null;
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint("Error al cerrar sesión: $e");
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

      developer.log("Perfil actualizado en Firestore: $nombre, $email",
          name: "FirebaseService");
    } catch (e) {
      developer.log("Error al actualizar el perfil: $e",
          name: "FirebaseService");
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
      // Log antes de actualizar
      developer.log(
          "Actualizando datos en Firestore - Peso: $peso, Altura: $altura",
          name: "FirebaseService");

      await _firestore.collection('users').doc(uid).update({
        'nivelExperiencia': nivelExperiencia,
        'peso': peso,
        'altura': altura,
        'objetivo': objetivo,
      });

      // Log después de actualizar
      developer.log("Datos actualizados en Firestore exitosamente",
          name: "FirebaseService");
    } catch (e) {
      developer.log("Error al actualizar el perfil: $e",
          name: "FirebaseService");
      throw Exception("No se pudo actualizar el perfil");
    }
  }

  // NUEVO: Método para actualizar solo el peso
  Future<void> updateUserWeight(String uid, double peso) async {
    try {
      developer.log("Actualizando solo el peso en Firestore: $peso",
          name: "FirebaseService");

      await _firestore.collection('users').doc(uid).update({
        'peso': peso,
      });

      developer.log("Peso actualizado en Firestore exitosamente",
          name: "FirebaseService");
    } catch (e) {
      developer.log("Error al actualizar el peso: $e", name: "FirebaseService");
      throw Exception("No se pudo actualizar el peso");
    }
  }
}
