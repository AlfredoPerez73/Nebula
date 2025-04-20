import 'dart:ui';

import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/controllers/training.controller.dart';
import 'package:nebula/src/views/pages/editProfilePageSkills.dart';
import 'package:nebula/src/views/pages/iMCCalculatorPage.dart';
import 'package:nebula/src/views/pages/routinesPage.dart';
import '../controllers/user.controller.dart';
import 'pages/profileScreen.dart';
import 'pages/exercisesPage.dart';
import '../utils/navigate_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreen> {
  final AuthController authController = Get.find<AuthController>();
  final EntrenamientoController entrenamientoController =
      Get.find<EntrenamientoController>();
  int _selectedIndex = 0;

  // Color palette based on the existing design
  static const Color _backgroundColor = Color(0xFF242038);
  static const Color _primaryColor = Color(0xFF9067C6);
  static const Color _accentColor = Color(0xFFF7ECE1);
  static const Color _secondaryColor = Color(0xFF8D86C9);

  // This method determines which content to show based on the selected index
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        entrenamientoController.cargarEntrenamientos();
        return _buildHomeContent();
      case 1:
        return const ExercisesPage();
      case 2:
        return Routinespage();
      case 3:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _backgroundColor,
              Color.lerp(_backgroundColor, _primaryColor, 0.4) ??
                  _primaryColor.withOpacity(0.8),
              _primaryColor.withOpacity(0.8),
            ],
            stops: const [0.2, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Elementos decorativos en el fondo
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.02),
                ),
              ),
            ),

            // Contenido principal
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  if (_selectedIndex == 0) _buildEnhancedAppBar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 90),
                      child: _getPage(_selectedIndex),
                    ),
                  ),
                ],
              ),
            ),

            // Navegación inferior
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavigation(
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
    );
  }

// Enhanced container decoration method
  BoxDecoration _enhancedCardDecoration(
      {Color? accentColor, double opacity = 0.1}) {
    final Color accent = accentColor ?? Colors.white;

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.12),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: accent.withOpacity(0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: _primaryColor.withOpacity(0.25),
          blurRadius: 15,
          spreadRadius: 1,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _buildEnhancedAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF242038),
                      const Color(0xFF242038).withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Color(0xFFF7ECE1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "NEBULA",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Color(0xFFF7ECE1),
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  authController.signOut();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Amicons.iconly_logout_curved_fill,
                        color: Color(0xFFF7ECE1),
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Salir",
                        style: TextStyle(
                          color: Color(0xFFF7ECE1),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
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
    );
  }

// Updated methods with improved visual design
  Widget _buildUserInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: _enhancedCardDecoration(accentColor: _accentColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tu perfil",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Amicons.iconly_add_user_curved_fill,
                  color: _accentColor,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() => Column(
                children: [
                  _buildEnhancedInfoRow(
                    Amicons.lucide_dumbbell,
                    "Nivel de experiencia",
                    authController.userModel.value?.nivelExperiencia ??
                        "Sin información",
                  ),
                  const SizedBox(height: 15),
                  _buildEnhancedInfoRow(
                    Amicons.flaticon_rings_wedding_rounded_fill,
                    "Peso",
                    "${authController.userModel.value?.peso.toString() ?? '0'} kg",
                  ),
                  const SizedBox(height: 15),
                  _buildEnhancedInfoRow(
                    Amicons.remix_line_height,
                    "Altura",
                    "${authController.userModel.value?.altura.toString() ?? '0'} cm",
                  ),
                  const SizedBox(height: 15),
                  _buildEnhancedInfoRow(
                    Amicons.flaticon_gym_rounded_fill,
                    "Objetivo",
                    authController.userModel.value?.objetivo ??
                        "Sin información",
                  ),
                ],
              )),
          const SizedBox(height: 25),
          _buildEnhancedButton(
            "Editar perfil",
            () => Get.to(() => const EditProfilePageSkills()),
            _backgroundColor,
          ),
        ],
      ),
    );
  }

// Reusable enhanced button method
  Widget _buildEnhancedButton(
      String text, VoidCallback onPressed, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                color,
                Color.lerp(color, _accentColor, 0.3) ?? color,
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: _accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Amicons.iconly_arrow_right_curved_fill,
                  color: _accentColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Home content for index 0
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bienvenida personalizada
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _accentColor.withOpacity(0.2),
                    _accentColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _accentColor.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Amicons.remix_health_book_fill,
                          color: _accentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bienvenido a",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFF7ECE1),
                            ),
                          ),
                          Text(
                            "TU GESTOR DE",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF7ECE1),
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            "ENTRENAMIENTO",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF7ECE1),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() => Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _accentColor.withOpacity(0.2),
                              border: Border.all(
                                color: _accentColor.withOpacity(0.4),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                authController.userModel.value?.nombre
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    'U',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: _accentColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${authController.userModel.value?.nombre ?? 'Usuario'}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF7ECE1),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "${authController.userModel.value?.email ?? 'Correo no disponible'}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFFCAC4CE)
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Información del usuario
            _buildUserInfoSection(),

            const SizedBox(height: 25),

            // Estadísticas del usuario
            _buildUserStatsCard(),

            const SizedBox(height: 25),

            // IMC Card
            _buildBMICard(),

            const SizedBox(height: 25),

            // Progreso del usuario
            _buildUserProgressCard(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF8D86C9).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF8D86C9),
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFCAC4CE).withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF7ECE1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMICard() {
    // Calculate BMI
    double? altura = authController.userModel.value?.altura;
    double? peso = authController.userModel.value?.peso;

    double bmi = altura != null && peso != null
        ? peso / ((altura / 100) * (altura / 100))
        : 0.0;

    // Determine BMI Category
    String getBMICategory(double bmi) {
      if (bmi < 18.5) return "Bajo peso";
      if (bmi < 25) return "Peso normal";
      if (bmi < 30) return "Sobrepeso";
      return "Obesidad";
    }

    // Get color based on BMI category
    Color getBMICategoryColor(double bmi) {
      if (bmi < 18.5) return const Color(0xFF3498DB); // Azul más intenso
      if (bmi < 25) return const Color(0xFF2ECC71); // Verde más intenso
      if (bmi < 30) return const Color(0xFFE67E22); // Naranja más intenso
      return const Color(0xFFE74C3C); // Rojo más intenso
    }

    String bmiCategory = getBMICategory(bmi);
    Color categoryColor = getBMICategoryColor(bmi);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con fondo de acento usando el color de la categoría BMI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoryColor,
                    Color.lerp(categoryColor, Colors.black, 0.3) ??
                        categoryColor,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Índice de Masa Corporal",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Amicons.iconly_chart_broken,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      bmiCategory,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenido principal
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  // Tarjetas de BMI y Categoría
                  Row(
                    children: [
                      Expanded(
                        child: _buildEnhancedBMIStatCard(
                          "IMC",
                          bmi.toStringAsFixed(1),
                          Amicons.remix_line_chart,
                          categoryColor,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildEnhancedBMIStatCard(
                          "Peso",
                          "${peso?.toStringAsFixed(1) ?? '0'} kg",
                          Amicons.iconly_swap_broken,
                          categoryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Consejo de salud con diseño mejorado
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Amicons.iconly_info_circle_broken,
                            color: categoryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Consejo de salud",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: categoryColor,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _getBMIHealthTip(bmiCategory),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.7),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botón mejorado
                  _buildImprovedButton(
                    "Más información",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BMICalculatorPage()),
                      );
                    },
                    categoryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedBMIStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            Color.lerp(color, Colors.black, 0.25) ?? color,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovedButton(String text, VoidCallback onTap, Color color) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                color,
                Color.lerp(color, Colors.black, 0.2) ?? color,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Amicons.iconly_arrow_right_broken,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getBMIHealthTip(String bmiCategory) {
    switch (bmiCategory) {
      case "Bajo peso":
        return "Considera consultar a un nutricionista para un plan de alimentación y ejercicio adecuado.";
      case "Peso normal":
        return "¡Mantén un estilo de vida saludable con dieta equilibrada y ejercicio regular!";
      case "Sobrepeso":
        return "Enfócate en reducir calorías y aumentar actividad física para mejorar tu salud.";
      case "Obesidad":
        return "Es importante consultar a un profesional de salud para desarrollar un plan integral.";
      default:
        return "Consulta a un profesional de salud para una evaluación personalizada.";
    }
  }

  Widget _buildUserStatsCard() {
    final authController = Get.find<AuthController>();

    return GetBuilder<EntrenamientoController>(builder: (controller) {
      // Calcular estadísticas basadas en datos reales
      int totalSesiones = 0;
      int totalMinutos = 0;
      int totalCalorias = 0;
      int totalLogros = 0;
      int maxLogros = 0;
      String nivelExperiencia =
          authController.userModel.value?.nivelExperiencia?.toLowerCase() ??
              "principiante";

      // Determinar metas según nivel de experiencia
      int metaSesiones = _getMetaSesiones(nivelExperiencia);
      int metaMinutos = _getMetaMinutos(nivelExperiencia);
      int metaCalorias = _getMetaCalorias(
          nivelExperiencia, authController.userModel.value?.peso ?? 70);

      if (controller.entrenamientos.isNotEmpty) {
        // Contar días únicos de entrenamiento para las sesiones
        Set<String> diasUnicos = {};

        for (var entrenamiento in controller.entrenamientos) {
          for (var ejercicio in entrenamiento.ejercicios) {
            diasUnicos.add(ejercicio.dia.toLowerCase());

            // Calcular tiempo aproximado por ejercicio (series * repeticiones * tiempo promedio)
            int tiempoEjercicio =
                ejercicio.series * int.parse(ejercicio.repeticiones) * 1 ~/ 1;
            totalMinutos += tiempoEjercicio;
          }
        }

        totalSesiones = diasUnicos.length;

        // Calorías (estimado basado en tiempo de entrenamiento y peso del usuario)
        double peso = authController.userModel.value?.peso ?? 70;
        totalCalorias = (totalMinutos * 7 * peso / 70).toInt();

        // Determinar logros disponibles según nivel
        maxLogros = _getMaxLogros(nivelExperiencia);

        // Logros basados en progreso y ajustados según nivel
        List<bool> logrosCompletados = [
          totalSesiones >= metaSesiones / 2,
          totalMinutos >= metaMinutos / 2,
          controller.entrenamientos.length >= 3,
          diasUnicos.length >= 4,
          totalCalorias >= metaCalorias / 2,
          totalSesiones >= metaSesiones,
          totalMinutos >= metaMinutos
        ];

        totalLogros = logrosCompletados.where((logro) => logro).length;
      }

      // Paleta de colores para las tarjetas - Todos tonos morados
      final List<Color> cardColors = [
        const Color(0xFF8E44AD), // Morado oscuro para sesiones
        const Color(0xFF9B59B6), // Morado medio para minutos
        const Color(0xFFAF7AC5), // Morado claro para calorías
        const Color(0xFF7D3C98), // Morado intenso para logros
      ];

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con fondo de acento
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _secondaryColor,
                      _secondaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Progreso",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Icon(
                            Amicons.iconly_chart_broken,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Nivel: ${nivelExperiencia.capitalizeFirst}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Tarjetas de estadísticas (2x2 grid)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMinimalStatCard(
                            "Sesiones",
                            totalSesiones,
                            metaSesiones,
                            Amicons.iconly_calendar_broken,
                            cardColors[0],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMinimalStatCard(
                            "Minutos",
                            totalMinutos,
                            metaMinutos,
                            Amicons.iconly_time_circle_broken,
                            cardColors[1],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMinimalStatCard(
                            "Calorías",
                            totalCalorias,
                            metaCalorias,
                            Amicons.remix_fire,
                            cardColors[2],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMinimalStatCard(
                            "Logros",
                            totalLogros,
                            maxLogros,
                            Amicons.vuesax_archive_minus,
                            cardColors[3],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMinimalStatCard(
      String title, int value, int target, IconData icon, Color color) {
    final double progress = (value / target).clamp(0.0, 1.0);
    final bool isComplete = progress >= 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            Color.lerp(color, Colors.deepPurple, 0.6) ?? color,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono con indicador circular
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3.5,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Título
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // Valor principal
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 3),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "/ $target",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          // Indicador de porcentaje
          const SizedBox(height: 8),
          Text(
            "${(progress * 100).toInt()}%",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isComplete ? Colors.white : Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProgressCard() {
    final authController = Get.find<AuthController>();
    final entrenamientoController = Get.find<EntrenamientoController>();

    // Paleta de colores premium
    final Color primaryPurple = const Color(0xFF6A11CB); // Púrpura profundo
    final Color secondaryPurple = const Color(0xFF8F6ED5); // Púrpura medio
    final Color accentPurple = const Color(0xFFB39DDB); // Púrpura claro
    final Color deepViolet = const Color(0xFF4527A0); // Violeta profundo
    final Color lightPurple = const Color(0xFFD1C4E9); // Púrpura muy claro

    return GetBuilder<EntrenamientoController>(builder: (controller) {
      // Variables para calcular progreso
      double progresoExperiencia = 0.0;
      String nivelActual =
          authController.userModel.value?.nivelExperiencia?.toLowerCase() ??
              "principiante";
      int totalRepeticiones = 0;
      int maxSeries = 0;
      String ejercicioFavorito = "Sin datos";

      // Determinar metas según nivel de experiencia
      int metaRepeticiones = _getMetaRepeticiones(nivelActual);
      int metaSeries = _getMetaSeries(nivelActual);

      // Calcular total de repeticiones y máximo de series
      Map<String, int> contadorEjercicios = {};

      for (var entrenamiento in controller.entrenamientos) {
        for (var ejercicio in entrenamiento.ejercicios) {
          totalRepeticiones +=
              ejercicio.series * int.parse(ejercicio.repeticiones);

          if (ejercicio.series > maxSeries) {
            maxSeries = ejercicio.series;
          }

          // Contar ejercicios para encontrar el favorito
          contadorEjercicios.update(ejercicio.nombre, (value) => value + 1,
              ifAbsent: () => 1);
        }
      }

      // Determinar ejercicio favorito
      int maxCount = 0;
      contadorEjercicios.forEach((nombre, count) {
        if (count > maxCount) {
          maxCount = count;
          ejercicioFavorito = nombre;
        }
      });

      // Calcular progreso de experiencia basado en nivel
      switch (nivelActual) {
        case "principiante":
          progresoExperiencia = 0.25;
          break;
        case "intermedio":
          progresoExperiencia = 0.5;
          break;
        case "avanzado":
          progresoExperiencia = 0.75;
          break;
        case "experto":
          progresoExperiencia = 1.0;
          break;
        default:
          progresoExperiencia = 0.1;
      }

      // Calcular progreso de repeticiones
      double progresoRepeticiones =
          (totalRepeticiones / metaRepeticiones).clamp(0.0, 1.0);

      // Calcular progreso de series
      double progresoSeries = (maxSeries / metaSeries).clamp(0.0, 1.0);

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con fondo de degradado
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 35),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryPurple,
                        deepViolet,
                      ],
                      stops: const [0.2, 1.0],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Amicons.remix_line_chart,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 15),
                              const Text(
                                "PROGRESO",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              nivelActual.capitalizeFirst ?? "Principiante",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        "Monitorea tus avances en cada área de entrenamiento",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.4,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Card Section
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildPremiumProgressCard(
                        title: "Experiencia",
                        value: nivelActual.capitalizeFirst ?? "Principiante",
                        detail: _getMensajeMotivacional(nivelActual),
                        progress: progresoExperiencia,
                        color: primaryPurple,
                        baseColor: secondaryPurple,
                        icon: Amicons.lucide_dumbbell,
                      ),
                      const SizedBox(height: 20),
                      _buildPremiumProgressCard(
                        title: "Total de Reps",
                        value: "$totalRepeticiones reps",
                        detail: "Meta: $metaRepeticiones",
                        progress: progresoRepeticiones,
                        color: secondaryPurple,
                        baseColor: primaryPurple,
                        icon: Amicons.remix_repeat,
                      ),
                      const SizedBox(height: 20),
                      _buildPremiumProgressCard(
                        title: "Ejercicio favorito",
                        value: ejercicioFavorito,
                        detail: "$maxSeries de $metaSeries series",
                        progress: progresoSeries,
                        color: accentPurple,
                        baseColor: deepViolet,
                        icon: Amicons.remix_heart_pulse,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPremiumProgressCard({
    required String title,
    required String value,
    required String detail,
    required double progress,
    required Color color,
    required Color baseColor,
    required IconData icon,
  }) {
    // Color del texto basado en si es una meta o un mensaje motivacional
    bool isGoal = detail.contains('Meta:') || detail.contains('de');

    Color textColor = Colors.white;
    Color accentTextColor =
        isGoal ? const Color(0xFFF1C40F) : const Color(0xFF2ECC71);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withOpacity(0.95),
            color.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: baseColor.withOpacity(0.25),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Parte superior con fondo de cristal
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                // Círculo de progreso
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${(progress * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: accentTextColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            detail,
                            style: TextStyle(
                              fontSize: 14,
                              color: accentTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Barra de progreso
          Container(
            height: 10,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutQuart,
                    width: progress * double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withOpacity(0.8),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

// Métodos auxiliares para calcular metas basadas en nivel de experiencia

// Metas de sesiones semanales
  int _getMetaSesiones(String nivel) {
    switch (nivel) {
      case "principiante":
        return 3;
      case "intermedio":
        return 4;
      case "avanzado":
        return 5;
      case "experto":
        return 6;
      default:
        return 3;
    }
  }

// Metas de minutos de entrenamiento semanales
  int _getMetaMinutos(String nivel) {
    switch (nivel) {
      case "principiante":
        return 120; // 2 horas
      case "intermedio":
        return 180; // 3 horas
      case "avanzado":
        return 240; // 4 horas
      case "experto":
        return 300; // 5 horas
      default:
        return 120;
    }
  }

// Metas de calorías quemadas semanales (ajustadas por peso)
  int _getMetaCalorias(String nivel, double peso) {
    int baseCalorias;
    switch (nivel) {
      case "principiante":
        baseCalorias = 500;
        break;
      case "intermedio":
        baseCalorias = 800;
        break;
      case "avanzado":
        baseCalorias = 1200;
        break;
      case "experto":
        baseCalorias = 1500;
        break;
      default:
        baseCalorias = 500;
    }

    // Ajustar por peso (70kg es el estándar, se ajusta proporcionalmente)
    return (baseCalorias * peso / 70).round();
  }

// Número máximo de logros disponibles según nivel
  int _getMaxLogros(String nivel) {
    switch (nivel) {
      case "principiante":
        return 4;
      case "intermedio":
        return 6;
      case "avanzado":
        return 7;
      case "experto":
        return 8;
      default:
        return 4;
    }
  }

// Meta de repeticiones totales según nivel
  int _getMetaRepeticiones(String nivel) {
    switch (nivel) {
      case "principiante":
        return 500;
      case "intermedio":
        return 800;
      case "avanzado":
        return 1200;
      case "experto":
        return 1500;
      default:
        return 500;
    }
  }

// Meta de series por ejercicio según nivel
  int _getMetaSeries(String nivel) {
    switch (nivel) {
      case "principiante":
        return 3;
      case "intermedio":
        return 4;
      case "avanzado":
        return 5;
      case "experto":
        return 6;
      default:
        return 3;
    }
  }

// Método auxiliar para mensajes motivacionales
  String _getMensajeMotivacional(String nivel) {
    switch (nivel) {
      case "principiante":
        return "¡Buen comienzo!";
      case "intermedio":
        return "¡Vas muy bien!";
      case "avanzado":
        return "¡Impresionante!";
      case "experto":
        return "¡Eres un pro!";
      default:
        return "¡Sigue así!";
    }
  }
}
