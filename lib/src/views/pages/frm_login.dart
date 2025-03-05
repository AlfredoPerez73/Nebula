import 'package:flutter/material.dart';
import 'package:nebula/src/utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "App Fitness con IA",
          style: TextStyle(
            color: AppColors.fondoColors,
          ),
        ),
      ),
      body: const Center(
        child: Text("Login de Usuario!"),
      ),
    );
  }
}
