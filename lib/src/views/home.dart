import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              _primaryColor.withOpacity(0.8),
            ],
            stops: [0.3, 1],
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  if (_selectedIndex == 0) _buildCustomAppBar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 90),
                      child: _getPage(_selectedIndex),
                    ),
                  ),
                ],
              ),
            ),
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
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: _primaryColor.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  // Updated methods with improved visual design
  Widget _buildUserInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tu perfil",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _accentColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Obx(() => Column(
                children: [
                  _buildInfoRow(
                    Amicons.lucide_dumbbell,
                    "Nivel de experiencia",
                    authController.userModel.value?.nivelExperiencia ??
                        "Sin información",
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    Amicons.flaticon_rings_wedding_rounded_fill,
                    "Peso",
                    "${authController.userModel.value?.peso.toString() ?? '0'} kg",
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    Amicons.remix_line_height,
                    "Altura",
                    "${authController.userModel.value?.altura.toString() ?? '0'} cm",
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    Amicons.flaticon_gym_rounded_fill,
                    "Objetivo",
                    authController.userModel.value?.objetivo ??
                        "Sin información",
                  ),
                ],
              )),
          const SizedBox(height: 15),
          _buildElevatedButton(
            "Editar perfil",
            () => Get.to(() => const EditProfilePageSkills()),
            _backgroundColor,
          ),
        ],
      ),
    );
  }

  // Reusable elevated button method
  Widget _buildElevatedButton(
      String text, VoidCallback onPressed, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 5,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _accentColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  // Home content for index 0
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bienvenida personalizada
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bienvenido a tu portal de entrenamiento",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF7ECE1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Text(
                        "Hola, ${authController.userModel.value?.nombre ?? 'Usuario'}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFFF7ECE1),
                        ),
                      )),
                  const SizedBox(height: 5),
                  Obx(() => Text(
                        "Email: ${authController.userModel.value?.email ?? 'Correo no disponible'}",
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFFCAC4CE).withOpacity(0.8),
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Información del usuario
            _buildUserInfoSection(),

            const SizedBox(height: 20),

            // Estadísticas del usuario
            _buildUserStatsCard(),

            const SizedBox(height: 20),

            // IMC Card (replaces User Preferences)
            _buildBMICard(),

            const SizedBox(height: 20),

            // Progreso del usuario
            _buildUserProgressCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF242038),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Color(0xFFF7ECE1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "NEBULA",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Color(0xFFF7ECE1),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Amicons.iconly_logout_curved_fill,
                color: Color(0xFFF7ECE1)),
            onPressed: () {
              authController.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF8D86C9),
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFFCAC4CE).withOpacity(0.8),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFF7ECE1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Existing methods remain the same: _buildUserStatsCard(), _buildUserProgressCard(), etc.

  // New BMI-related methods
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
      if (bmi < 18.5) return Colors.blue.withOpacity(0.6);
      if (bmi < 25) return Colors.green.withOpacity(0.6);
      if (bmi < 30) return Colors.orange.withOpacity(0.6);
      return Colors.red.withOpacity(0.6);
    }

    String bmiCategory = getBMICategory(bmi);
    Color categoryColor = getBMICategoryColor(bmi);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Índice de Masa Corporal",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                  letterSpacing: 1.1,
                ),
              ),
              Icon(
                Amicons.iconly_chart_broken,
                color: _secondaryColor,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildBMIStatCard(
                  "IMC",
                  bmi.toStringAsFixed(1),
                  Amicons.remix_line_chart,
                  categoryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildBMIStatCard(
                  "Categoría",
                  bmiCategory,
                  Amicons.iconly_info_circle_broken,
                  categoryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Amicons.iconly_info_circle_broken,
                  color: _secondaryColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _getBMIHealthTip(bmiCategory),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF7ECE1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _buildElevatedButton(
            "Más información",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BMICalculatorPage()),
              );
            },
            _primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBMIStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Estadísticas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                  letterSpacing: 1.1,
                ),
              ),
              Icon(
                Amicons.iconly_chart_broken,
                color: _secondaryColor,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "Sesiones",
                  "27",
                  Amicons.iconly_calendar_broken,
                  Colors.blue.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  "Minutos",
                  "840",
                  Amicons.iconly_time_circle_broken,
                  Colors.green.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "Calorías",
                  "9,350",
                  Amicons.remix_fire,
                  Colors.orange.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  "Logros",
                  "5",
                  Amicons.vuesax_archive_minus,
                  Colors.purple.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProgressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05)
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tu progreso",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                  letterSpacing: 1.1,
                ),
              ),
              Icon(
                Amicons.remix_line_chart,
                color: _secondaryColor,
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildProgressTracker(
            title: "Peso",
            current: "75 kg",
            change: "-2.5 kg",
            progress: 0.7,
            color: Colors.cyan,
            icon: Amicons.flaticon_rings_wedding_rounded_fill,
          ),
          const SizedBox(height: 15),
          _buildProgressTracker(
            title: "Fuerza",
            current: "Press de banca",
            change: "+10 kg",
            progress: 0.6,
            color: Colors.amber,
            icon: Amicons.lucide_dumbbell,
          ),
          const SizedBox(height: 15),
          _buildProgressTracker(
            title: "Resistencia",
            current: "30 min. cardio",
            change: "+8 min.",
            progress: 0.8,
            color: Colors.greenAccent,
            icon: Amicons.remix_heart_pulse,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTracker({
    required String title,
    required String current,
    required String change,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: _secondaryColor,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFF7ECE1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: change.contains('+')
                      ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 14,
                    color: change.contains('+')
                        ? Colors.green[100]
                        : Colors.red[100],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                current,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 8,
                width: MediaQuery.of(context).size.width * progress - 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
