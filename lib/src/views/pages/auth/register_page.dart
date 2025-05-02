import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user.controller.dart';
import 'package:amicons/amicons.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers para todos los campos
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  // Values for dropdowns
  String _selectedNivelExperiencia = 'Principiante';
  String _selectedObjetivo = 'Perder peso';

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

  // Para controlar el paso actual del registro (1 o 2)
  final RxInt _currentStep = 1.obs;

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
              Color(0xFF242038), // Dark purple
              Color(0xFF9067C6), // Lighter purple
            ],
            stops: [0.3, 1.0], // Make the dark color more dominant
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background geometric elements for a more powerful look
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF9067C6).withValues(alpha: 0.2),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -100,
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF242038).withValues(alpha: 0.3),
                  ),
                ),
              ),
              // Subtle diagonal lines for a tech/powerful look
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
                painter: DiagonalLinesPainter(),
              ),

              // Main content
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 20.0),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF242038).withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Enhanced Logo
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF242038),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF9067C6)
                                      .withValues(alpha: 0.5),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Amicons
                                  .lucide_dumbbell, // Usando ícono de amicons relacionado con fitness
                              color: Color(0xFFF7ECE1),
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Enhanced title with shadow for depth
                          ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Color(0xFFF7ECE1), Color(0xFFCAC4CE)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds);
                            },
                            child: const Text(
                              "NEBULA",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4.0,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFF9067C6),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Create Account subtitle with enhanced styling
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xFF9067C6)
                                  .withValues(alpha: 0.15),
                              border: Border.all(
                                color: const Color(0xFF9067C6)
                                    .withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Amicons
                                      .iconly_add_user_fill, // Ícono de amicons para añadir usuario
                                  color: Color(0xFFF7ECE1),
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "CREATE ACCOUNT",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    color: Color(0xFFF7ECE1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Indicador de pasos
                          _buildStepIndicator(),
                          const SizedBox(height: 25),

                          // Mostrar el formulario según el paso actual
                          Obx(() => _currentStep.value == 1
                              ? _buildStep1Form()
                              : _buildStep2Form()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Indicador de pasos (1/2 o 2/2)
  Widget _buildStepIndicator() {
    return Obx(() => Row(
          children: [
            _buildStepCircle(1, _currentStep.value >= 1),
            Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9067C6),
                      _currentStep.value > 1
                          ? const Color(0xFF9067C6)
                          : const Color(0xFF9067C6).withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),
            _buildStepCircle(2, _currentStep.value >= 2),
          ],
        ));
  }

  // Círculo para cada paso
  Widget _buildStepCircle(int step, bool isActive) {
    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF9067C6) : Colors.transparent,
        border: Border.all(
          color: const Color(0xFF9067C6),
          width: 2,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF9067C6).withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFFCAC4CE),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Paso 1: Formulario de datos de cuenta
  Widget _buildStep1Form() {
    return Column(
      children: [
        // Información de usuario
        _buildTextField(
            controller: _usernameController,
            label: "Username",
            icon: Amicons.vuesax_personalcard),
        const SizedBox(height: 16),
        _buildTextField(
            controller: _emailController,
            label: "Email",
            icon: Amicons.flaticon_envelope_marker_rounded_fill),
        const SizedBox(height: 14),
        _buildTextField(
            controller: _passwordController,
            label: "Password",
            isPassword: true,
            icon: Amicons.iconly_password_curved),
        const SizedBox(height: 30),

        // Botón de siguiente paso con ícono
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9067C6).withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            gradient: const LinearGradient(
              colors: [
                Color(0xFF9067C6),
                Color(0xFF8D86C9),
              ],
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              // Validar datos del paso 1
              if (_usernameController.text.isEmpty ||
                  _emailController.text.isEmpty ||
                  _passwordController.text.isEmpty) {
                Get.snackbar(
                  "Error",
                  "Por favor, complete todos los campos",
                  backgroundColor: Colors.red.withValues(alpha: 0.6),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(15),
                  borderRadius: 10,
                );
                return;
              }

              // Validar formato de email
              if (!_emailController.text.contains('@')) {
                Get.snackbar(
                  "Error",
                  "Por favor, ingrese un email válido",
                  backgroundColor: Colors.red.withValues(alpha: 0.6),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(15),
                  borderRadius: 10,
                );
                return;
              }

              // Avanzar al paso 2
              _currentStep.value = 2;
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Siguiente",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Amicons
                        .remix_arrow_drop_right, // Ícono de amicons para avanzar
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Enhanced separator
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFCAC4CE).withValues(alpha: 0.1),
                      const Color(0xFFCAC4CE).withValues(alpha: 0.5),
                      const Color(0xFFCAC4CE).withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OR",
                style: TextStyle(
                  color: Color(0xFFCAC4CE),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFCAC4CE).withValues(alpha: 0.1),
                      const Color(0xFFCAC4CE).withValues(alpha: 0.5),
                      const Color(0xFFCAC4CE).withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Enhanced login button con ícono
        TextButton.icon(
          onPressed: () {
            Get.back(); // Navigate back to login page
          },
          icon: const Icon(Amicons.vuesax_signpost_fill,
              size: 18), // Ícono de amicons para login
          label: const Text(
            "BACK TO LOGIN",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            foregroundColor: const Color(0xFFF7ECE1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: const Color(0xFFF7ECE1).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Paso 2: Formulario de datos físicos
  Widget _buildStep2Form() {
    return Column(
      children: [
        // Información física
        _buildTextField(
            controller: _pesoController,
            label: "Peso (kg)",
            icon: Amicons.vuesax_weight), // Ícono de peso
        const SizedBox(height: 16),
        _buildTextField(
            controller: _alturaController,
            label: "Altura (cm)",
            icon: Amicons.vuesax_rulerpen), // Ícono de medida
        const SizedBox(height: 16),

        // Dropdown para nivel de experiencia
        _buildDropdown(
          label: "Nivel de Experiencia",
          icon: Amicons.iconly_star, // Ícono de medalla para nivel
          value: _selectedNivelExperiencia,
          items: _nivelesExperiencia,
          onChanged: (String? newValue) {
            setState(() {
              _selectedNivelExperiencia = newValue!;
            });
          },
        ),
        const SizedBox(height: 16),

        // Dropdown para objetivo
        _buildDropdown(
          label: "Objetivo",
          icon: Amicons.vuesax_archive_minus, // Ícono de objetivo
          value: _selectedObjetivo,
          items: _objetivos,
          onChanged: (String? newValue) {
            setState(() {
              _selectedObjetivo = newValue!;
            });
          },
        ),
        const SizedBox(height: 30),

        // Botones de navegación con íconos
        Row(
          children: [
            // Botón atrás con ícono
            Expanded(
              child: TextButton.icon(
                onPressed: () {
                  // Volver al paso 1
                  _currentStep.value = 1;
                },
                icon: const Icon(Amicons.iconly_arrow_left_2_curved,
                    size: 18), // Ícono para regresar
                label: const Text(
                  "ATRÁS",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  foregroundColor: const Color(0xFFF7ECE1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: const Color(0xFFF7ECE1).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Botón de registro con ícono
            Expanded(
              flex: 2,
              child: Obx(() => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9067C6).withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9067C6),
                          Color(0xFF8D86C9),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: _authController.isLoading.value
                          ? null
                          : () async {
                              // Validar campos obligatorios del paso 2
                              if (_pesoController.text.isEmpty ||
                                  _alturaController.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Por favor, complete todos los campos",
                                  backgroundColor:
                                      Colors.red.withValues(alpha: 0.6),
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(15),
                                  borderRadius: 10,
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
                                  backgroundColor:
                                      Colors.red.withValues(alpha: 0.6),
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(15),
                                  borderRadius: 10,
                                );
                                return;
                              }

                              // Registrar usuario con todos los datos
                              await _authController.register(
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text,
                                _selectedNivelExperiencia,
                                peso,
                                altura,
                                _selectedObjetivo,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: _authController.isLoading.value
                            ? const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Amicons
                                        .lucide_circle_check, // Ícono de completar
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Completar",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  )),
            ),
          ],
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
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF8D86C9).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icono prefijo
          Container(
            margin: const EdgeInsets.only(left: 16, right: 8),
            child: Icon(
              icon,
              color: const Color(0xFF9067C6),
              size: 22,
            ),
          ),

          // Campo de texto sin decoración
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword && !_isPasswordVisible,
              style: const TextStyle(
                color: Color(0xFFF7ECE1),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                // Sin label, usamos solo placeholder
                hintText: label,
                hintStyle: TextStyle(
                  color: const Color(0xFFCAC4CE).withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                // Quitar completamente todos los bordes
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                // Sin padding horizontal para evitar desplazamientos
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                // Sin color de relleno
                filled: false,
              ),
            ),
          ),

          // Icono de sufijo (solo para contraseñas)
          if (isPassword)
            IconButton(
              icon: Icon(
                _isPasswordVisible ? Amicons.remix_eye_off : Amicons.remix_eye,
                color: const Color(0xFF8D86C9),
                size: 22,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            )
          else
            // Espacio equivalente para mantener el padding consistente
            const SizedBox(width: 16),
        ],
      ),
    );
  }

  // Enhanced dropdown fields
  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF8D86C9).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          // This customizes dropdown menu style
          popupMenuTheme: PopupMenuThemeData(
            color: const Color(0xFF242038).withValues(alpha: 0.95),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF9067C6), size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    dropdownColor:
                        const Color(0xFF242038).withValues(alpha: 0.95),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8D86C9).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Amicons.iconly_arrow_down_2_curved,
                        color: Color(0xFF9067C6),
                        size: 18,
                      ),
                    ),
                    isExpanded: true,
                    style: const TextStyle(
                      color: Color(0xFFF7ECE1),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: onChanged,
                    items: items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                    // Add alignment to ensure dropdown text is properly positioned
                    alignment: Alignment.centerLeft,
                    // Remove hint to prevent overlapping with the selected value
                    hint: null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for diagonal lines background effect
class DiagonalLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9067C6).withValues(alpha: 0.05)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < size.width + size.height; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(0, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
