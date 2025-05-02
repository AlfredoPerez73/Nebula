import 'package:flutter/material.dart';
import 'register_page.dart';
import 'package:get/get.dart';
import 'package:amicons/amicons.dart';
import '../../../controllers/user.controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Initialize the auth controller
  final AuthController _authController = Get.put(AuthController());

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
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
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                              Amicons.lucide_dumbbell,
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
                          const SizedBox(height: 12),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "A partir de Inteligencia Artificial desarrollamos tus entrenamientos en base a objetivos personales",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFCAC4CE),
                                height: 1.4,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),

                          // Enhanced text fields
                          _buildTextField(
                            controller: _usernameOrEmailController,
                            label: "Username o Email",
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _passwordController,
                            label: "Password",
                            isPassword: true,
                            icon: Icons.lock_outline,
                          ),
                          const SizedBox(height: 30),

                          // Enhanced login button with gradient
                          Obx(() => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF9067C6)
                                          .withValues(alpha: 0.5),
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
                                          await _authController.login(
                                            _usernameOrEmailController.text
                                                .trim(),
                                            _passwordController.text.trim(),
                                          );
                                        },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    elevation: 0,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Center(
                                      child: _authController.isLoading.value
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : const Text(
                                              "LOG IN",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              )),
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
                                        const Color(0xFFCAC4CE)
                                            .withValues(alpha: 0.1),
                                        const Color(0xFFCAC4CE)
                                            .withValues(alpha: 0.5),
                                        const Color(0xFFCAC4CE)
                                            .withValues(alpha: 0.1),
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
                                        const Color(0xFFCAC4CE)
                                            .withValues(alpha: 0.1),
                                        const Color(0xFFCAC4CE)
                                            .withValues(alpha: 0.5),
                                        const Color(0xFFCAC4CE)
                                            .withValues(alpha: 0.1),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Enhanced create account button
                          TextButton(
                            onPressed: () {
                              Get.to(() => const RegisterPage());
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              foregroundColor: const Color(0xFFF7ECE1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: const Color(0xFFF7ECE1)
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              "CREATE ACCOUNT",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF9067C6),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        style: const TextStyle(
          color: Color(0xFFF7ECE1),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: const Color(0xFFCAC4CE).withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF9067C6),
            size: 22,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF8D86C9),
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.black.withValues(alpha: 0.15),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: const Color(0xFF8D86C9).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: const Color(0xFF9067C6).withValues(alpha: 0.5),
              width: 1.5,
            ),
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
