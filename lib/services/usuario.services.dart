import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.model.dart';

class UsuarioService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Registrar un nuevo usuario en Firestore
  Future<void> registrarUsuario(Usuario usuario) async {
    try {
      await _db
          .collection("usuarios")
          .doc(usuario.idUsuario)
          .set(usuario.toJson());
    } catch (e) {
      print("Error al registrar usuario: $e");
    }
  }

  // Obtener un usuario por ID
  Future<Usuario?> getUsuario(String idUsuario) async {
    DocumentSnapshot doc =
        await _db.collection("usuarios").doc(idUsuario).get();
    if (doc.exists) {
      return Usuario.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Eliminar un usuario
  Future<void> deleteUsuario(String idUsuario) async {
    await _db.collection("usuarios").doc(idUsuario).delete();
  }
}
