import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user.controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  // Values for dropdowns
  String _selectedNivelExperiencia = 'Principiante';
  String _selectedObjetivo = 'Pérdida de peso';

  // Options for dropdowns
  final List<String> _nivelesExperiencia = [
    'Principiante',
    'Intermedio',
    'Avanzado',
    'Experto'
  ];

  final List<String> _objetivos = [
    'Perder peso',
    'Ganar masa muscular',
    'Mantener forma física',
    'Mejorar resistencia'
  ];

  // Initialize the auth controller
  final AuthController _authController = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
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
                      _buildFullRegistrationForm(),
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

  Widget _buildFullRegistrationForm() {
    return Column(
      children: [
        // Información de usuario
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
        const SizedBox(height: 12),

        // Dropdown para nivel de experiencia
        _buildDropdown(
          label: "Nivel de Experiencia",
          icon: Icons.star_outline,
          value: _selectedNivelExperiencia,
          items: _nivelesExperiencia,
          onChanged: (String? newValue) {
            setState(() {
              _selectedNivelExperiencia = newValue!;
            });
          },
        ),
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

        // Dropdown para objetivo
        _buildDropdown(
          label: "Objetivo",
          icon: Icons.flag_outlined,
          value: _selectedObjetivo,
          items: _objetivos,
          onChanged: (String? newValue) {
            setState(() {
              _selectedObjetivo = newValue!;
            });
          },
        ),
        const SizedBox(height: 25),

        // Botón de registro
        Obx(() => ElevatedButton(
              onPressed: _authController.isLoading.value
                  ? null
                  : () async {
                      // Validar campos obligatorios
                      if (_usernameController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _passwordController.text.isEmpty ||
                          _pesoController.text.isEmpty ||
                          _alturaController.text.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Por favor, complete todos los campos",
                          backgroundColor: Colors.red.withOpacity(0.6),
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Validar formato de email
                      if (!_emailController.text.contains('@')) {
                        Get.snackbar(
                          "Error",
                          "Por favor, ingrese un email válido",
                          backgroundColor: Colors.red.withOpacity(0.6),
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Validar valores numéricos
                      double peso;
                      double altura;
                      try {
                        peso = double.parse(_pesoController.text);
                        altura = double.parse(_alturaController.text);
                      } catch (e) {
                        Get.snackbar(
                          "Error",
                          "Por favor, ingrese valores numéricos para peso y altura",
                          backgroundColor: Colors.red.withOpacity(0.6),
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Registrar usuario con los valores de los dropdowns
                      await _authController.register(
                        _usernameController.text,
                        _emailController.text,
                        _passwordController.text,
                        _selectedNivelExperiencia, // Usar el valor seleccionado
                        peso,
                        altura,
                        _selectedObjetivo, // Usar el valor seleccionado
                      );
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: const Color(0xFF9067C6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: _authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                ),
              ),
            )),
        const SizedBox(height: 16),

        // Separador
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: const Color(0xFFCAC4CE).withOpacity(0.3),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
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

        // Botón para ir a Login
        TextButton(
          onPressed: () {
            Get.back(); // Navigate back to login page
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

  // New method to build dropdown fields
  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF8D86C9), size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  dropdownColor: const Color(0xFF242038),
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Color(0xFF8D86C9)),
                  isExpanded: true,
                  hint: Text(
                    label,
                    style: TextStyle(
                      color: const Color(0xFFCAC4CE).withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  style: const TextStyle(
                    color: Color(0xFFF7ECE1),
                    fontSize: 14,
                  ),
                  onChanged: onChanged,
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
