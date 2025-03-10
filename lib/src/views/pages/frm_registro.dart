import 'package:flutter/material.dart';
import 'package:nebula/src/views/pages/frm_login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nivelExperienciaController =
      TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _objetivoController = TextEditingController();

  bool _isPasswordVisible = false;
  int _step = 1;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nivelExperienciaController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    _objetivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF242038),
              Color(0xFF9067C6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo y título
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF242038),
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: Color(0xFFF7ECE1),
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "NEBULA",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                          color: Color(0xFFF7ECE1),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                          color: Color(0xFFF7ECE1),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_step == 1) _buildStepOne(),
                      if (_step == 2) _buildStepTwo(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepOne() {
    return Column(
      children: [
        _buildTextField(
            controller: _usernameController,
            label: "Username",
            icon: Icons.person_outline),
        const SizedBox(height: 12),
        _buildTextField(
            controller: _emailController,
            label: "Email",
            icon: Icons.email_outlined),
        const SizedBox(height: 12),
        _buildTextField(
            controller: _passwordController,
            label: "Password",
            isPassword: true,
            icon: Icons.lock_outline),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _step = 2;
            });
          },
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            backgroundColor: const Color(0xFF9067C6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            elevation: 0,
          ),
          child: const Center(
            child: Text("Next",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFCAC4CE).withOpacity(0.3),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                "or",
                style: TextStyle(
                  color: Color(0xFFCAC4CE),
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFCAC4CE).withOpacity(0.3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            foregroundColor: const Color(0xFFF7ECE1),
          ),
          child: const Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepTwo() {
    return Column(
      children: [
        _buildTextField(
            controller: _nivelExperienciaController,
            label: "Nivel de Experiencia",
            icon: Icons.star_outline),
        const SizedBox(height: 12),
        _buildTextField(
            controller: _pesoController,
            label: "Peso (kg)",
            icon: Icons.fitness_center),
        const SizedBox(height: 12),
        _buildTextField(
            controller: _alturaController,
            label: "Altura (cm)",
            icon: Icons.height),
        const SizedBox(height: 12),
        _buildTextField(
            controller: _objetivoController,
            label: "Objetivo",
            icon: Icons.flag_outlined),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            backgroundColor: const Color(0xFF9067C6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            elevation: 0,
          ),
          child: const Center(
            child: Text("Register",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        style: const TextStyle(color: Color(0xFFF7ECE1)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: const Color(0xFFCAC4CE).withOpacity(0.7), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF8D86C9), size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF8D86C9),
                      size: 20),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
      ),
    );
  }
}
