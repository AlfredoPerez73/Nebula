import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/views/pages/editProfilePageSkills.dart';
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
        child: Stack(
          children: [
            // Content (with bottom padding to account for navigation bar)
            SafeArea(
              bottom: false, // Important: Don't apply safe area at bottom
              child: Column(
                children: [
                  // Only show the app bar on the home screen
                  if (_selectedIndex == 0) _buildCustomAppBar(),

                  // Main content area with padding bottom for navbar
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 90), // Add padding for navbar
                      child: _getPage(_selectedIndex),
                    ),
                  ),
                ],
              ),
            ),

            // Transparent Navigation Bar
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
      extendBody: true, // Important for transparency effect
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

            // Sección de entrenamientos
            _buildWorkoutSection(),
          ],
        ),
      ),
    );
  }

  // Resto del código no cambia...
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

  Widget _buildUserInfoSection() {
    return Container(
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
            "Tu perfil",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),
          const SizedBox(height: 15),

          // Información del usuario
          Obx(() => _buildInfoRow(
                Amicons.lucide_dumbbell,
                "Nivel de experiencia",
                authController.userModel.value?.nivelExperiencia ??
                    "Sin información",
              )),
          const SizedBox(height: 10),

          Obx(() => _buildInfoRow(
                Amicons.flaticon_rings_wedding_rounded_fill,
                "Peso",
                "${authController.userModel.value?.peso.toString() ?? '0'} kg",
              )),
          const SizedBox(height: 10),

          Obx(() => _buildInfoRow(
                Amicons.remix_line_height,
                "Altura",
                "${authController.userModel.value?.altura.toString() ?? '0'} cm",
              )),
          const SizedBox(height: 10),

          Obx(() => _buildInfoRow(
                Amicons.flaticon_gym_rounded_fill,
                "Objetivo",
                authController.userModel.value?.objetivo ?? "Sin información",
              )),

          const SizedBox(height: 15),

          // Botón para editar perfil
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const EditProfilePageSkills());
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: const Color.fromARGB(255, 6, 6, 7),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Editar perfil"),
            ),
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

  Widget _buildWorkoutSection() {
    return Container(
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
            "Entrenamientos recomendados",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),
          const SizedBox(height: 15),

          // Listado de entrenamientos
          _buildWorkoutCard(
            "Entrenamiento Completo",
            "Entrenamiento de cuerpo completo para principiantes",
            Amicons.flaticon_gym_rounded_fill,
            Colors.blue.withOpacity(0.4),
          ),
          const SizedBox(height: 10),

          _buildWorkoutCard(
            "Cardio Intenso",
            "30 minutos de ejercicio cardiovascular",
            Amicons.remix_walk_fill,
            Colors.red.withOpacity(0.4),
          ),
          const SizedBox(height: 10),

          _buildWorkoutCard(
            "Estiramiento",
            "Rutina de estiramiento para mejorar la flexibilidad",
            Amicons.flaticon_head_side_thinking_rounded,
            Colors.green.withOpacity(0.4),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Implementar navegación a la pantalla de entrenamientos
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: const Color(0xFF9067C6),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Ver todos los entrenamientos"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(
      String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }
}
