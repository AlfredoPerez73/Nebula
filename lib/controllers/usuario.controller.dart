import 'package:flutter/material.dart';
import '../models/usuario.model.dart';
import '../services/usuario.services.dart';

class UsuarioController with ChangeNotifier {
  final UsuarioService _usuarioService = UsuarioService();
  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;

  // Cargar usuario desde Firestore
  Future<void> cargarUsuario(String idUsuario) async {
    _usuarioActual = await _usuarioService.getUsuario(idUsuario);
    notifyListeners();
  }

  // Guardar usuario en Firestore
  Future<void> guardarUsuario(Usuario usuario) async {
    await _usuarioService.registrarUsuario(usuario);
    _usuarioActual = usuario;
    notifyListeners();
  }

  // Eliminar usuario
  Future<void> eliminarUsuario(String idUsuario) async {
    await _usuarioService.deleteUsuario(idUsuario);
    _usuarioActual = null;
    notifyListeners();
  }
}
