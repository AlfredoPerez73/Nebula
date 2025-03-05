import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/usuario.controller.dart';
import '../models/usuario.model.dart';

class UsuarioScreen extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nivelExperienciaController =
      TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController objetivoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final usuarioController = Provider.of<UsuarioController>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Registro de Usuario")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: pesoController,
              decoration: InputDecoration(labelText: "Peso"),
            ),
            TextField(
              controller: alturaController,
              decoration: InputDecoration(labelText: "Altura"),
            ),
            TextField(
              controller: objetivoController,
              decoration: InputDecoration(labelText: "Objetivo(s)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final usuario = Usuario(
                  idUsuario: DateTime.now().millisecondsSinceEpoch.toString(),
                  nombre: nombreController.text,
                  email: emailController.text,
                  nivelExperiencia: nivelExperienciaController.text,
                  peso: double.parse(pesoController.text), // Convierte a double
                  altura: double.parse(alturaController.text),
                  objetivo: objetivoController.text,
                );

                usuarioController.guardarUsuario(usuario);
              },
              child: Text("Registrar Usuario"),
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: usuarioController.cargarUsuario("123456"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final usuario = usuarioController.usuarioActual;
                if (usuario == null) {
                  return Center(child: Text("No se encontró el usuario"));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nombre: ${usuario.nombre}",
                        style: TextStyle(fontSize: 18)),
                    Text("Email: ${usuario.email}",
                        style: TextStyle(fontSize: 18)),
                    Text("Nivel de Experiencia: ${usuario.nivelExperiencia}",
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        usuarioController.eliminarUsuario(usuario.idUsuario);
                      },
                      child: Text("Eliminar Usuario"),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
