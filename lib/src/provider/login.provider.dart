import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { notAuthentication, cheking, authenticated }

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthStatus authStatus = AuthStatus.notAuthentication;

  Future<void> loginUser({
    required String usernameOrEmail,
    required String password,
    required String token,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      //para el nombre de usuario

      authStatus = AuthStatus.cheking;
      notifyListeners();
      final String usernameOrEmailLowerCase = usernameOrEmail.toLowerCase();
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('username_lowercase', isEqualTo: usernameOrEmailLowerCase)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        final String email = result.docs.first.get('email');
        final UserCredential userCredential = await _auth
            .signInWithEmailAndPassword(email: email, password: password);
        onSuccess();
        return;
      }
      //para el correo de usuario
      final QuerySnapshot resultEmail = await _firestore
          .collection('users')
          .where('email', isEqualTo: usernameOrEmailLowerCase)
          .limit(1)
          .get();

      if (resultEmail.docs.isEmpty) {
        final String email = result.docs.first.get('email');
        final UserCredential userCredential = await _auth
            .signInWithEmailAndPassword(email: email, password: password);
        onSuccess();
        return;
      }

      onError("No se encontro el usuario ingresado");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        onError("No se encontro el usuario ingresado");
      } else {
        onError(e.toString());
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  //verfiicar el estado del usuario
  void checkAuthState() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        authStatus = AuthStatus.notAuthentication;
      } else {
        authStatus = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  //obtener datos del usuario
  Future<dynamic> getUserData(String email) async {
    final QuerySnapshot<Map<String, dynamic>> result = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      final userData = result.docs[0].data();
      return userData;
    }
    return null;
  }
}
