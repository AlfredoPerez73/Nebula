import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializar Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness AI App',
      home: Scaffold(
        appBar: AppBar(title: Text("Bienvenido a Fitness AI")),
        body: Center(child: Text("Firebase configurado con éxito 🎉")),
      ),
    );
  }
}
