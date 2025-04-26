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

// Tarjeta de recomendación IA
            _buildAIRecommendationCard(),

            const SizedBox(height: 25),

            // Estadísticas del usuario
            _buildUserStatsCard(),

            const SizedBox(height: 25),

            // IMC Card
            _buildBMICard(),

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
                        "IMC",
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

  Widget _buildAIRecommendationCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF5D4777), // Púrpura más conservador
            const Color(0xFF6E5287), // Púrpura secundario más suave
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5D4777).withOpacity(0.25),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Encabezado de la tarjeta
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Amicons.lucide_brain,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Recomendación IA",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Basado en tu perfil y objetivos",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Línea divisoria con efecto de cristal
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withOpacity(0.01),
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.01),
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),

                // Contenido de la tarjeta
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        String nivelExperiencia = authController
                                .userModel.value?.nivelExperiencia
                                ?.toLowerCase() ??
                            "principiante";
                        String objetivo = authController
                                .userModel.value?.objetivo
                                ?.toLowerCase() ??
                            "mantenimiento";

                        // Personalizar mensaje según nivel y objetivo
                        String mensaje = _getPersonalizedRecommendation(
                            nivelExperiencia, objetivo);

                        return Text(
                          mensaje,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      // Botón de recomendación personalizada
                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            // Implementar acción para generar recomendación personalizada
                            _showAIRecommendationDialog();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Amicons.lucide_brain_cog,
                                  color: Color(0xFF6A11CB),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Generar recomendación personalizada",
                                  style: TextStyle(
                                    color: Color(0xFF6A11CB),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Método auxiliar para determinar la recomendación personalizada
  String _getPersonalizedRecommendation(String nivel, String objetivo) {
    if (nivel == "avanzado" && objetivo == "ganar masa muscular") {
      return "Para tu nivel Avanzado y tu objetivo de Ganar masa muscular, te recomendamos:\n\n• 5 sesiones semanales de alta intensidad\n• Enfoque en series compuestas y dropsets\n• Distribución push/pull/legs con 2 días de descanso";
    } else if (nivel == "intermedio" && objetivo == "definición") {
      return "Para tu nivel Intermedio y tu objetivo de Definición muscular, te recomendamos:\n\n• 4 sesiones semanales con cardio HIIT\n• Supersets y circuitos de alta repetición\n• Control de macronutrientes con déficit calórico moderado";
    } else if (nivel == "principiante" && objetivo == "perder peso") {
      return "Para tu nivel Principiante y tu objetivo de Perder peso, te recomendamos:\n\n• 3 sesiones de entrenamiento full-body\n• Combinación de cardio suave y musculación básica\n• Enfoque en técnica y progresión gradual";
    } else {
      return "Para tu nivel ${nivel.capitalizeFirst} y tu objetivo de ${objetivo.capitalizeFirst}, te recomendamos un plan personalizado. Presiona el botón para recibir recomendaciones adaptadas a tu perfil específico.";
    }
  }

// Método para mostrar el diálogo con la recomendación IA detallada
  // Método para mostrar el diálogo con la recomendación IA detallada incluyendo tarjetas de rutina
// Método modificado para mostrar un diálogo con entrada tipo chat y respuestas en tarjetas
  // Método modificado para mostrar un diálogo con entrada tipo chat y respuestas en tarjetas
  void _showAIRecommendationDialog() {
    // Controlador para el campo de texto
    final TextEditingController inputController = TextEditingController();

    // Variable para controlar estados de carga
    final RxBool isLoading = false.obs;

    // Variable para controlar si se debe mostrar la respuesta
    final RxBool showResponse = false.obs;

    // Variables para la consulta del usuario
    final RxString userQuery = "".obs;

    String nivelExperiencia =
        authController.userModel.value?.nivelExperiencia?.toLowerCase() ??
            "principiante";
    String objetivo = authController.userModel.value?.objetivo?.toLowerCase() ??
        "mantenimiento";

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          // Aumentamos el maxHeight para dar más espacio
          constraints: BoxConstraints(
            maxHeight: Get.height * 1.0, // Usar 80% de la altura de la pantalla
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF242038),
                Color(0xFF35305B),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Encabezado del diálogo
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF5D4777),
                      const Color(0xFF5D4777).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Amicons.lucide_brain_circuit,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "NEBULA IA",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Asistente de entrenamiento",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.8),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Cuerpo con tarjetas
              Expanded(
                child: Obx(() {
                  if (showResponse.value) {
                    // Mostrar la respuesta en formato de tarjetas de rutina
                    return _buildAIResponseContent(userQuery.value);
                  } else {
                    // Mostrar mensaje de bienvenida y explicación
                    return Container(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Imagen o icono destacado
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF9067C6).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Amicons.lucide_brain,
                              color: Color(0xFF9067C6),
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Mensaje de bienvenida
                          Text(
                            "Hola ${authController.userModel.value?.nombre ?? 'Usuario'}, ¿cómo estás?",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),

                          // Mensaje explicativo
                          Text(
                            "Soy tu asistente de entrenamiento personalizado. Puedo ayudarte con rutinas, nutrición, consejos y más.\n\nEscribe tu pregunta en el campo de abajo.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          // Sugerencias de preguntas
                          const SizedBox(height: 30),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildSuggestionChip(
                                  "Rutina para ${objetivo.capitalizeFirst}"),
                              _buildSuggestionChip("Ejercicios para pecho"),
                              _buildSuggestionChip("Consejos de nutrición"),
                              _buildSuggestionChip("Rutina de 3 días"),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                }),
              ),

              // Indicador de carga
              Obx(
                () => isLoading.value
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9067C6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF9067C6)),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "NEBULA IA está preparando tu rutina",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Personalizando según tu nivel ${nivelExperiencia.capitalizeFirst}...",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.7),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Campo de entrada
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: inputController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Escribe tu pregunta aquí...",
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15),
                          ),
                          maxLines: 1,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _processAIQuery(inputController,
                              isLoading, showResponse, userQuery),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => _processAIQuery(inputController, isLoading,
                            showResponse, userQuery),
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF9067C6),
                                Color(0xFF8D86C9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF9067C6).withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Amicons.iconly_send_curved_fill,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

// Chip de sugerencia para preguntas frecuentes
  Widget _buildSuggestionChip(String text) {
    return InkWell(
      onTap: () {
        // Al hacer clic en una sugerencia, se establece como consulta
        final TextEditingController tempController =
            TextEditingController(text: text);
        // Usamos valores Rx existentes en lugar de crear nuevos
        final RxBool isLoading = false.obs;
        final RxBool showResponse = true.obs;
        final RxString userQuery = text.obs;
        _processAIQuery(tempController, isLoading, showResponse, userQuery);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }

// Método para procesar la consulta del usuario y mostrar la respuesta
  void _processAIQuery(TextEditingController controller, RxBool isLoading,
      RxBool showResponse, RxString userQuery) {
    // Validar que la consulta no esté vacía
    if (controller.text.trim().isEmpty) return;

    // Guardar la consulta del usuario
    userQuery.value = controller.text.trim();

    // Mostrar indicador de carga
    isLoading.value = true;

    // Simular tiempo de procesamiento (aquí se podría hacer una llamada real a una API)
    Future.delayed(const Duration(seconds: 2), () {
      // Ocultar indicador de carga
      isLoading.value = false;

      // Mostrar la respuesta
      showResponse.value = true;

      // Limpiar el campo de texto
      controller.clear();
    });
  }

// Método para construir el contenido de la respuesta (tarjetas de rutina)
  Widget _buildAIResponseContent(String query) {
    final String nivelExperiencia =
        authController.userModel.value?.nivelExperiencia?.toLowerCase() ??
            "principiante";
    final String objetivo =
        authController.userModel.value?.objetivo?.toLowerCase() ??
            "mantenimiento";

    // Aquí puedes personalizar las respuestas según la consulta del usuario
    // Este es un ejemplo simplificado
    List<Map<String, dynamic>> rutinas =
        _generateRutinasBasedOnQuery(query, nivelExperiencia, objetivo);

    final RxBool showResponse = false.obs;

    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de la respuesta
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9067C6).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Amicons.lucide_brain_circuit,
                        color: Color(0xFF9067C6),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Basado en tu consulta: \"$query\"",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "He preparado estas rutinas para ti:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Lista de tarjetas de rutina
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: rutinas.map((rutina) {
                  return _buildRutinaCard(rutina);
                }).toList(),
              ),
            ),
          ),

          // Botón para volver a preguntar
          const SizedBox(height: 15),
          Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Volver al estado inicial
                  showResponse.value = false;
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "Realizar otra consulta",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Método para generar rutinas basadas en la consulta
  List<Map<String, dynamic>> _generateRutinasBasedOnQuery(
      String query, String nivel, String objetivo) {
    // Aquí implementarías la lógica real para generar rutinas basadas en la consulta
    // Este es un ejemplo simplificado

    final List<Map<String, dynamic>> rutinas = [];

    // Análisis simple de la consulta para determinar qué tipo de rutina generar
    final bool isRutinaPecho = query.toLowerCase().contains("pecho");
    final bool isRutinaCompleta = query.toLowerCase().contains("completa") ||
        query.toLowerCase().contains("full");
    final bool isRutina3Dias = query.toLowerCase().contains("3 días") ||
        query.toLowerCase().contains("tres días");
    final bool isNutricion = query.toLowerCase().contains("nutrición") ||
        query.toLowerCase().contains("dieta");

    if (isRutinaPecho) {
      // Rutina de pecho
      rutinas.add({
        "titulo": "Rutina de Pecho",
        "descripcion":
            "Entrenamiento completo para desarrollo del pecho adaptado a tu nivel $nivel",
        "color": const Color(0xFF8D86C9),
        "icono": Amicons.lucide_dumbbell,
        "duracion": "45-60 min",
        "nivel": nivel.capitalizeFirst,
        "ejercicios": [
          {"nombre": "Press de banca", "series": 4, "repeticiones": "10-12"},
          {
            "nombre": "Aperturas con mancuernas",
            "series": 3,
            "repeticiones": "12-15"
          },
          {
            "nombre": "Fondos en paralelas",
            "series": 3,
            "repeticiones": "8-10"
          },
          {"nombre": "Press inclinado", "series": 3, "repeticiones": "10-12"},
          {"nombre": "Pullover", "series": 3, "repeticiones": "12-15"},
        ]
      });
    } else if (isRutina3Dias) {
      // Rutina de 3 días
      rutinas.add({
        "titulo": "Día 1: Pecho y Tríceps",
        "descripcion":
            "Enfocado en el desarrollo de la parte superior del cuerpo",
        "color": const Color(0xFF9067C6),
        "icono": Amicons.lucide_dumbbell,
        "duracion": "50-60 min",
        "nivel": nivel.capitalizeFirst,
        "ejercicios": [
          {"nombre": "Press de banca", "series": 4, "repeticiones": "10-12"},
          {
            "nombre": "Press inclinado con mancuernas",
            "series": 3,
            "repeticiones": "10-12"
          },
          {
            "nombre": "Aperturas en polea",
            "series": 3,
            "repeticiones": "12-15"
          },
          {
            "nombre": "Extensiones de tríceps en polea",
            "series": 3,
            "repeticiones": "12-15"
          },
          {"nombre": "Fondos en banco", "series": 3, "repeticiones": "12-15"},
        ]
      });

      rutinas.add({
        "titulo": "Día 2: Espalda y Bíceps",
        "descripcion": "Rutina para fortalecer la espalda y los brazos",
        "color": const Color(0xFF8D86C9),
        "icono": Amicons.lucide_dumbbell,
        "duracion": "50-60 min",
        "nivel": nivel.capitalizeFirst,
        "ejercicios": [
          {"nombre": "Dominadas", "series": 4, "repeticiones": "8-10"},
          {"nombre": "Remo con barra", "series": 3, "repeticiones": "10-12"},
          {"nombre": "Pulldown al pecho", "series": 3, "repeticiones": "12-15"},
          {"nombre": "Curl con barra", "series": 3, "repeticiones": "10-12"},
          {"nombre": "Curl martillo", "series": 3, "repeticiones": "12-15"},
        ]
      });

      rutinas.add({
        "titulo": "Día 3: Piernas y Hombros",
        "descripcion": "Entrenamiento para piernas y hombros",
        "color": const Color(0xFF5D4777),
        "icono": Amicons.lucide_dumbbell,
        "duracion": "50-60 min",
        "nivel": nivel.capitalizeFirst,
        "ejercicios": [
          {"nombre": "Sentadillas", "series": 4, "repeticiones": "10-12"},
          {"nombre": "Prensa de piernas", "series": 3, "repeticiones": "12-15"},
          {
            "nombre": "Extensiones de cuádriceps",
            "series": 3,
            "repeticiones": "12-15"
          },
          {"nombre": "Press militar", "series": 3, "repeticiones": "10-12"},
          {
            "nombre": "Elevaciones laterales",
            "series": 3,
            "repeticiones": "12-15"
          },
        ]
      });
    } else if (isNutricion) {
      // Recomendaciones de nutrición
      rutinas.add({
        "titulo": "Plan Nutricional",
        "descripcion":
            "Recomendaciones nutricionales para tu objetivo de $objetivo",
        "color": const Color(0xFF9067C6),
        "icono": Amicons.lucide_ice_cream_bowl,
        "duracion": "Plan diario",
        "nivel": nivel.capitalizeFirst,
        "ejercicios": [
          {
            "nombre": "Desayuno",
            "series": 0,
            "repeticiones": "Avena con frutas y proteína"
          },
          {
            "nombre": "Media mañana",
            "series": 0,
            "repeticiones": "Yogur con frutos secos"
          },
          {
            "nombre": "Almuerzo",
            "series": 0,
            "repeticiones":
                "Proteína magra con verduras y carbohidratos complejos"
          },
          {
            "nombre": "Merienda",
            "series": 0,
            "repeticiones": "Batido de proteínas con plátano"
          },
          {
            "nombre": "Cena",
            "series": 0,
            "repeticiones": "Pescado o pollo con ensalada"
          },
        ]
      });

      rutinas.add({
        "titulo": "Suplementación",
        "descripcion": "Suplementos recomendados para complementar tu dieta",
        "color": const Color(0xFF8D86C9),
        "icono": Amicons.lucide_pill,
        "duracion": "Diario",
        "nivel": nivel.capitalizeFirst,
        "ejercicios": [
          {
            "nombre": "Proteína Whey",
            "series": 0,
            "repeticiones": "20-30g post-entrenamiento"
          },
          {"nombre": "Creatina", "series": 0, "repeticiones": "5g diarios"},
          {
            "nombre": "Vitamina D",
            "series": 0,
            "repeticiones": "2000-4000 UI diarias"
          },
          {"nombre": "Omega-3", "series": 0, "repeticiones": "1-2g diarios"},
          {
            "nombre": "Magnesio",
            "series": 0,
            "repeticiones": "300-400mg antes de dormir"
          },
        ]
      });
    } else {
      // Rutina general o personalizada según objetivo
      String tituloRutina = "Rutina para $objetivo";

      if (objetivo == "volumen" || objetivo == "hipertrofia") {
        rutinas.add({
          "titulo": tituloRutina,
          "descripcion": "Rutina enfocada en ganar masa muscular",
          "color": const Color(0xFF9067C6),
          "icono": Amicons.lucide_dumbbell,
          "duracion": "60-75 min",
          "nivel": nivel.capitalizeFirst,
          "ejercicios": [
            {"nombre": "Press de banca", "series": 4, "repeticiones": "8-10"},
            {"nombre": "Dominadas", "series": 4, "repeticiones": "8-10"},
            {"nombre": "Sentadillas", "series": 4, "repeticiones": "8-10"},
            {"nombre": "Press militar", "series": 3, "repeticiones": "8-10"},
            {"nombre": "Peso muerto", "series": 3, "repeticiones": "6-8"},
          ]
        });
      } else if (objetivo == "definicion" || objetivo == "definición") {
        rutinas.add({
          "titulo": tituloRutina,
          "descripcion": "Rutina enfocada en quemar grasa y definir músculos",
          "color": const Color(0xFF8D86C9),
          "icono": Amicons.lucide_dumbbell,
          "duracion": "45-60 min",
          "nivel": nivel.capitalizeFirst,
          "ejercicios": [
            {
              "nombre": "Circuito de press",
              "series": 3,
              "repeticiones": "12-15"
            },
            {
              "nombre": "Superseries de remo",
              "series": 3,
              "repeticiones": "12-15"
            },
            {
              "nombre": "HIIT de sentadillas",
              "series": 4,
              "repeticiones": "15-20"
            },
            {
              "nombre": "Superseries de hombro",
              "series": 3,
              "repeticiones": "15-20"
            },
            {
              "nombre": "Circuito de core",
              "series": 3,
              "repeticiones": "20-25"
            },
          ]
        });
      } else {
        // Rutina de mantenimiento o general
        rutinas.add({
          "titulo": "Rutina Full Body",
          "descripcion": "Entrenamiento completo para todo el cuerpo",
          "color": const Color(0xFF9067C6),
          "icono": Amicons.lucide_dumbbell,
          "duracion": "50-60 min",
          "nivel": nivel.capitalizeFirst,
          "ejercicios": [
            {"nombre": "Press de banca", "series": 3, "repeticiones": "10-12"},
            {"nombre": "Remo con barra", "series": 3, "repeticiones": "10-12"},
            {"nombre": "Sentadillas", "series": 3, "repeticiones": "10-12"},
            {"nombre": "Press militar", "series": 3, "repeticiones": "10-12"},
            {"nombre": "Curl con barra", "series": 2, "repeticiones": "12-15"},
          ]
        });
      }
    }

    // Si no hay rutinas generadas (consulta no reconocida), crear una rutina genérica
    if (rutinas.isEmpty) {
      rutinas.add({
        "titulo": "Rutina Personalizada",
        "descripcion": "Basada en tu nivel $nivel y objetivo de $objetivo",
        "color": const Color(0xFF9067C6),
        "icono": Amicons.lucide_dumbbell,
        "duracion": "45-60 min",
        "nivel": nivel.capitalizeFirst,
        "ejercicios": [
          {"nombre": "Press de banca", "series": 3, "repeticiones": "10-12"},
          {"nombre": "Sentadillas", "series": 3, "repeticiones": "10-12"},
          {"nombre": "Remo con barra", "series": 3, "repeticiones": "10-12"},
          {"nombre": "Press militar", "series": 3, "repeticiones": "10-12"},
          {"nombre": "Peso muerto", "series": 3, "repeticiones": "8-10"},
        ]
      });
    }

    return rutinas;
  }

// Método para construir la tarjeta de rutina
  Widget _buildRutinaCard(Map<String, dynamic> rutina) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            rutina["color"],
            rutina["color"].withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: rutina["color"].withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Encabezado de la tarjeta
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    rutina["icono"],
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rutina["titulo"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        rutina["descripcion"],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Amicons.lucide_clock,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  rutina["duracion"],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Amicons.lucide_zap,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  rutina["nivel"],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    onPressed: () {
                      // Aquí puedes implementar la navegación a la vista detallada de la rutina
                      // Get.to(() => RutinaDetailView(rutina: rutina));
                    },
                  ),
                ),
              ],
            ),
          ),

          // Lista de ejercicios
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ejercicio",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Series",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 25),
                        Text(
                          "Reps",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 12),
                ...rutina["ejercicios"].map<Widget>((ejercicio) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            ejercicio["nombre"],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 30,
                              alignment: Alignment.center,
                              child: Text(
                                ejercicio["series"].toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              width: 45,
                              alignment: Alignment.center,
                              child: Text(
                                ejercicio["repeticiones"].toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    // Acción para guardar o iniciar la rutina
                    Get.back(); // Cerrar el diálogo
                    // Get.to(() => RutinaDetailView(rutina: rutina)); // Navegar a la vista detallada
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          rutina["color"],
                          rutina["color"].withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: rutina["color"].withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Iniciar Rutina",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Detalles del ejercicio (series, repeticiones, descanso)
  Widget _buildExerciseDetail(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.7),
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

// Método para obtener el color según el día de la semana
  Color _getDayColor(String dia) {
    switch (dia) {
      case 'Lunes':
        return const Color(0xFF4A90E2); // Azul
      case 'Martes':
        return const Color(0xFF50C878); // Esmeralda
      case 'Miércoles':
        return const Color(0xFF9D65C9); // Púrpura
      case 'Jueves':
        return const Color(0xFFFF6B6B); // Coral
      case 'Viernes':
        return const Color(0xFFFFD166); // Ámbar
      case 'Sábado':
        return const Color(
            0xFF5D4777); // Púrpura oscuro (como el tema principal)
      case 'Domingo':
        return const Color(0xFF2E4057); // Azul oscuro
      default:
        return const Color(0xFF6E5287); // Color predeterminado (púrpura tema)
    }
  }

// Método para obtener el enfoque del entrenamiento según el nivel y objetivo
  String _getTrainingFocus(String nivel, String objetivo) {
    if (nivel == "avanzado" && objetivo == "ganar masa muscular") {
      return "Hipertrofia con énfasis en peso y volumen progresivo";
    } else if (nivel == "intermedio" && objetivo == "definición") {
      return "Alta repetición con descansos cortos y supersets";
    } else if (nivel == "principiante" && objetivo == "perder peso") {
      return "Circuitos full-body y cardio suave integrado";
    } else if (objetivo == "ganar masa muscular") {
      return "Entrenamiento de hipertrofia con enfoque en compuestos";
    } else if (objetivo == "definición") {
      return "Combinación de resistencia y cardio estratégico";
    } else if (objetivo == "perder peso") {
      return "Entrenamiento mixto con déficit calórico";
    } else {
      return "Entrenamiento general para acondicionamiento físico";
    }
  }

// Método para obtener la intensidad del entrenamiento según el nivel y objetivo
  String _getTrainingIntensity(String nivel, String objetivo) {
    if (nivel == "avanzado") {
      return "Alta (75-85% de 1RM)";
    } else if (nivel == "intermedio") {
      return "Media-alta (65-75% de 1RM)";
    } else {
      return "Media-baja (50-65% de 1RM)";
    }
  }

  // Método para construir el widget de día de descanso
  Widget _buildRestDayContent(List<Map<String, dynamic>> ejerciciosDia) {
    bool esCardio = ejerciciosDia.isNotEmpty &&
        ejerciciosDia[0]['grupo'].toString().toLowerCase().contains('cardio');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            esCardio
                ? Amicons.iconly_activity_broken
                : Icons.night_shelter_sharp,
            color: Colors.white.withOpacity(0.7),
            size: 50,
          ),
          const SizedBox(height: 20),
          Text(
            esCardio ? "Cardio Ligero" : "Día de Recuperación",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              esCardio
                  ? "Realiza actividad cardiovascular."
                  : "El descanso es parte esencial del progreso.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(Map<String, dynamic> ejercicio, int index) {
    // Extraer valores con seguridad para evitar errores de tipo nulo
    final nombre = ejercicio['nombre'] as String? ?? "Ejercicio sin nombre";
    final series = ejercicio['series'] ?? 0;
    final repeticiones = ejercicio['repeticiones'] ?? "0";

    return Container(
      margin: EdgeInsets.only(bottom: index < 3 ? 15 : 0),
      child: Row(
        children: [
          // Número de ejercicio
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Detalles del ejercicio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$series series × $repeticiones",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Método para mostrar snackbar informativo
  void _showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFF5D4777),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 10,
      icon: const Icon(
        Amicons.iconly_tick_square_broken,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
    );
  }

// Métodos auxiliares para generar recomendaciones personalizadas
  List<String> _getDiasRecomendados(String nivel) {
    switch (nivel) {
      case "principiante":
        return ["Lunes", "Miércoles", "Viernes"];
      case "intermedio":
        return ["Lunes", "Martes", "Jueves", "Viernes"];
      case "avanzado":
        return ["Lunes", "Martes", "Miércoles", "Viernes", "Sábado"];
      case "experto":
        return ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
      default:
        return ["Lunes", "Miércoles", "Viernes"];
    }
  }

  // Método para obtener ejercicios recomendados según nivel y objetivo
  List<Map<String, dynamic>> _getEjerciciosRecomendados(
      String nivel, String objetivo) {
    // Lista de ejercicios recomendados según el nivel y objetivo
    List<Map<String, dynamic>> rutina = [];

    // Implementación para diferentes niveles y objetivos
    if (nivel == "avanzado" && objetivo == "ganar masa muscular") {
      rutina = [
        {
          'dia': 'Lunes',
          'grupo': 'Pecho y Tríceps',
          'ejercicios': [
            {
              'nombre': 'Press de banca inclinado',
              'series': 4,
              'repeticiones': '8-10'
            },
            {
              'nombre': 'Press con mancuernas',
              'series': 4,
              'repeticiones': '8-10'
            },
            {
              'nombre': 'Fondos en paralelas',
              'series': 3,
              'repeticiones': '10-12'
            },
            {
              'nombre': 'Extensión de tríceps',
              'series': 3,
              'repeticiones': '10-12'
            },
          ]
        },
        {
          'dia': 'Martes',
          'grupo': 'Espalda y Bíceps',
          'ejercicios': [
            {
              'nombre': 'Dominadas con peso',
              'series': 4,
              'repeticiones': '6-8'
            },
            {'nombre': 'Remo con barra', 'series': 4, 'repeticiones': '8-10'},
            {
              'nombre': 'Curl de bíceps con barra',
              'series': 3,
              'repeticiones': '8-10'
            },
            {'nombre': 'Curl martillo', 'series': 3, 'repeticiones': '10-12'},
          ]
        },
        {
          'dia': 'Miércoles',
          'grupo': 'Descanso Activo',
          'ejercicios': [
            {
              'nombre': 'Estiramiento completo',
              'series': 1,
              'repeticiones': '15-20 min'
            },
            {
              'nombre': 'Cardio suave',
              'series': 1,
              'repeticiones': '20-30 min'
            },
          ]
        },
        {
          'dia': 'Jueves',
          'grupo': 'Piernas',
          'ejercicios': [
            {
              'nombre': 'Sentadillas con barra',
              'series': 5,
              'repeticiones': '6-8'
            },
            {'nombre': 'Peso muerto', 'series': 4, 'repeticiones': '6-8'},
            {
              'nombre': 'Extensión de cuádriceps',
              'series': 3,
              'repeticiones': '10-12'
            },
            {
              'nombre': 'Curl de isquiotibiales',
              'series': 3,
              'repeticiones': '10-12'
            },
          ]
        },
        {
          'dia': 'Viernes',
          'grupo': 'Hombros y Trapecios',
          'ejercicios': [
            {'nombre': 'Press militar', 'series': 4, 'repeticiones': '8-10'},
            {
              'nombre': 'Elevaciones laterales',
              'series': 4,
              'repeticiones': '10-12'
            },
            {'nombre': 'Encogimientos', 'series': 4, 'repeticiones': '10-12'},
            {'nombre': 'Remo al mentón', 'series': 3, 'repeticiones': '10-12'},
          ]
        },
        {
          'dia': 'Sábado',
          'grupo': 'Brazos (enfoque)',
          'ejercicios': [
            {
              'nombre': 'Extensión de tríceps con polea',
              'series': 4,
              'repeticiones': '10-12'
            },
            {
              'nombre': 'Curl de bíceps con polea',
              'series': 4,
              'repeticiones': '10-12'
            },
            {'nombre': 'Press francés', 'series': 3, 'repeticiones': '8-10'},
            {'nombre': 'Curl concentrado', 'series': 3, 'repeticiones': '8-10'},
          ]
        },
        {
          'dia': 'Domingo',
          'grupo': 'Descanso Completo',
          'ejercicios': [
            {'nombre': 'Descanso total', 'series': 0, 'repeticiones': '0'},
          ]
        },
      ];
    } else if (nivel == "intermedio" && objetivo == "definición") {
      rutina = [
        {
          'dia': 'Lunes',
          'grupo': 'Pecho y Core',
          'ejercicios': [
            {'nombre': 'Press de banca', 'series': 4, 'repeticiones': '12-15'},
            {
              'nombre': 'Aperturas con mancuernas',
              'series': 3,
              'repeticiones': '12-15'
            },
            {
              'nombre': 'Plancha frontal',
              'series': 3,
              'repeticiones': '30-45 seg'
            },
            {
              'nombre': 'Crunch abdominal',
              'series': 3,
              'repeticiones': '15-20'
            },
          ]
        },
        {
          'dia': 'Martes',
          'grupo': 'Espalda y HIIT',
          'ejercicios': [
            {'nombre': 'Dominadas', 'series': 3, 'repeticiones': '8-10'},
            {
              'nombre': 'Remo con mancuerna',
              'series': 3,
              'repeticiones': '12-15'
            },
            {
              'nombre': 'HIIT (intervalos alta intensidad)',
              'series': 10,
              'repeticiones': '30seg/30seg'
            },
          ]
        },
        {
          'dia': 'Miércoles',
          'grupo': 'Descanso Activo',
          'ejercicios': [
            {
              'nombre': 'Yoga o Movilidad',
              'series': 1,
              'repeticiones': '30 min'
            },
          ]
        },
        {
          'dia': 'Jueves',
          'grupo': 'Piernas y Glúteos',
          'ejercicios': [
            {'nombre': 'Sentadillas', 'series': 4, 'repeticiones': '12-15'},
            {
              'nombre': 'Estocadas',
              'series': 3,
              'repeticiones': '10-12 por pierna'
            },
            {'nombre': 'Hip thrust', 'series': 4, 'repeticiones': '12-15'},
            {
              'nombre': 'Elevación de talones',
              'series': 3,
              'repeticiones': '15-20'
            },
          ]
        },
        {
          'dia': 'Viernes',
          'grupo': 'Hombros y Brazos',
          'ejercicios': [
            {
              'nombre': 'Press hombro con mancuernas',
              'series': 3,
              'repeticiones': '12-15'
            },
            {
              'nombre': 'Elevaciones laterales',
              'series': 3,
              'repeticiones': '12-15'
            },
            {'nombre': 'Curl de bíceps', 'series': 3, 'repeticiones': '12-15'},
            {
              'nombre': 'Extensión de tríceps',
              'series': 3,
              'repeticiones': '12-15'
            },
          ]
        },
        {
          'dia': 'Sábado',
          'grupo': 'Cardio y Core',
          'ejercicios': [
            {
              'nombre': 'Cardio estable (running/ciclismo)',
              'series': 1,
              'repeticiones': '30-40 min'
            },
            {
              'nombre': 'Circuito de abdominales',
              'series': 3,
              'repeticiones': '15 reps x 4 ejerc'
            },
          ]
        },
        {
          'dia': 'Domingo',
          'grupo': 'Descanso Completo',
          'ejercicios': [
            {'nombre': 'Descanso total', 'series': 0, 'repeticiones': '0'},
          ]
        },
      ];
    } else if (nivel == "principiante" && objetivo == "perder peso") {
      rutina = [
        {
          'dia': 'Lunes',
          'grupo': 'Full Body',
          'ejercicios': [
            {
              'nombre': 'Sentadillas con peso corporal',
              'series': 3,
              'repeticiones': '12-15'
            },
            {
              'nombre': 'Flexiones modificadas',
              'series': 3,
              'repeticiones': '8-12'
            },
            {
              'nombre': 'Peso muerto con mancuernas',
              'series': 3,
              'repeticiones': '10-12'
            },
            {
              'nombre': 'Plancha frontal',
              'series': 3,
              'repeticiones': '20-30 seg'
            },
          ]
        },
        {
          'dia': 'Martes',
          'grupo': 'Cardio Ligero',
          'ejercicios': [
            {
              'nombre': 'Caminata rápida o trote suave',
              'series': 1,
              'repeticiones': '30-40 min'
            },
            {
              'nombre': 'Estiramientos completos',
              'series': 1,
              'repeticiones': '10-15 min'
            },
          ]
        },
        {
          'dia': 'Miércoles',
          'grupo': 'Full Body',
          'ejercicios': [
            {
              'nombre': 'Estocadas',
              'series': 3,
              'repeticiones': '10 por pierna'
            },
            {
              'nombre': 'Remo con mancuernas',
              'series': 3,
              'repeticiones': '12-15'
            },
            {
              'nombre': 'Press de hombros',
              'series': 3,
              'repeticiones': '10-12'
            },
            {
              'nombre': 'Elevación de cadera',
              'series': 3,
              'repeticiones': '15-20'
            },
          ]
        },
        {
          'dia': 'Jueves',
          'grupo': 'Descanso Activo',
          'ejercicios': [
            {
              'nombre': 'Yoga o Estiramientos',
              'series': 1,
              'repeticiones': '20-30 min'
            },
          ]
        },
        {
          'dia': 'Viernes',
          'grupo': 'Full Body',
          'ejercicios': [
            {
              'nombre': 'Sentadillas sumo',
              'series': 3,
              'repeticiones': '12-15'
            },
            {'nombre': 'Fondos en banco', 'series': 3, 'repeticiones': '10-12'},
            {
              'nombre': 'Curl de bíceps con mancuernas',
              'series': 3,
              'repeticiones': '12-15'
            },
            {
              'nombre': 'Plancha lateral',
              'series': 3,
              'repeticiones': '20-30 seg por lado'
            },
          ]
        },
        {
          'dia': 'Sábado',
          'grupo': 'Cardio Moderado',
          'ejercicios': [
            {
              'nombre': 'Cardio intervalado suave',
              'series': 1,
              'repeticiones': '20-30 min'
            },
            {
              'nombre': 'Abdominales básicos',
              'series': 3,
              'repeticiones': '12-15'
            },
          ]
        },
        {
          'dia': 'Domingo',
          'grupo': 'Descanso Completo',
          'ejercicios': [
            {'nombre': 'Descanso total', 'series': 0, 'repeticiones': '0'},
          ]
        },
      ];
    } else {
      // Rutina por defecto para cualquier otra combinación
      rutina = [
        {
          'dia': 'Lunes',
          'grupo': 'Full Body',
          'ejercicios': [
            {'nombre': 'Sentadillas', 'series': 3, 'repeticiones': '10-12'},
            {'nombre': 'Press de banca', 'series': 3, 'repeticiones': '10-12'},
            {'nombre': 'Remo con barra', 'series': 3, 'repeticiones': '10-12'},
            {'nombre': 'Plancha', 'series': 3, 'repeticiones': '30 seg'},
          ]
        },
        {
          'dia': 'Miércoles',
          'grupo': 'Full Body',
          'ejercicios': [
            {'nombre': 'Peso muerto', 'series': 3, 'repeticiones': '10-12'},
            {
              'nombre': 'Press de hombros',
              'series': 3,
              'repeticiones': '10-12'
            },
            {
              'nombre': 'Dominadas asistidas',
              'series': 3,
              'repeticiones': '8-10'
            },
            {
              'nombre': 'Crunch abdominal',
              'series': 3,
              'repeticiones': '15-20'
            },
          ]
        },
        {
          'dia': 'Viernes',
          'grupo': 'Full Body',
          'ejercicios': [
            {
              'nombre': 'Estocadas',
              'series': 3,
              'repeticiones': '10 por pierna'
            },
            {
              'nombre': 'Fondos en paralelas',
              'series': 3,
              'repeticiones': '8-10'
            },
            {'nombre': 'Curl de bíceps', 'series': 3, 'repeticiones': '10-12'},
            {
              'nombre': 'Plancha lateral',
              'series': 3,
              'repeticiones': '20 seg por lado'
            },
          ]
        },
        {
          'dia': 'Martes',
          'grupo': 'Cardio Suave',
          'ejercicios': [
            {
              'nombre': 'Cardio de baja intensidad',
              'series': 1,
              'repeticiones': '20-30 min'
            },
          ]
        },
        {
          'dia': 'Sábado',
          'grupo': 'Cardio Suave',
          'ejercicios': [
            {
              'nombre': 'Cardio de baja intensidad',
              'series': 1,
              'repeticiones': '20-30 min'
            },
          ]
        },
      ];
    }

    return rutina;
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
