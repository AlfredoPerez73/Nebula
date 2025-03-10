import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum UserRole { admin, user, superAdmin }

class RegisterProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RegisterProvider() {
    //checkSign();
  }

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required String role,
    required String nivelExperiencia,
    required double peso,
    required double altura,
    required String objetivo,
    required String token,
    required String createdAt,
    //required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final String usernameLowerCase = username.toLowerCase();

      final bool userExist = await checkUser(usernameLowerCase);
      if (userExist) {
        onError("El usuario ya existe");
        return;
      }

      //verificar credenciales
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User user = userCredential.user!;
      final String userId = user.uid;

      final data = {
        'id': userId,
        'username': username,
        'password': password,
        'email': email,
        'role': role,
        'nivelExperiencia': nivelExperiencia,
        'peso': peso,
        'altura': altura,
        'objetivo': objetivo,
        'token': token,
        'createdAt': createdAt,
      };
      await _firestore.collection('users').doc(userId).set(data);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError("Contraseña muy debil");
      } else if (e.code == 'email-already-in-use') {
        onError("El email ya esdta en uso");
      }
    } catch (e) {
      onError("Error al registrar usuario");
    }
  }

  Future<bool> checkUser(String usernameLowerCase) async {
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('username', isEqualTo: usernameLowerCase)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<bool> checkEmail(String emailLowerCase) async {
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: emailLowerCase)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }
}
