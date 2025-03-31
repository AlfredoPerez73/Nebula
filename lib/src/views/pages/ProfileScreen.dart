import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/views/pages/workoutHistoryPage.dart';
import 'package:nebula/src/views/pages/EditProfilePage.dart';
import 'package:nebula/src/views/pages/iMCCalculatorPage.dart';
import 'package:nebula/src/widgets/charts.dart';
import '../../controllers/user.controller.dart';
import 'package:amicons/amicons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();

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
              Color(0xFF725AC1),
              Color(0xFF9067C6),
            ],
            stops: [0.1, 0.6, 1.0],
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

            SafeArea(
              child: Column(
                children: [
                  // Appbar personalizada
                  _buildEnhancedAppBar(),

                  // Contenido principal
                  Expanded(
                    child: _buildMainContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      const Color(0xFF9067C6),
                      const Color(0xFF8D86C9),
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
                  Amicons.lucide_user_round_cog,
                  color: Color(0xFFF7ECE1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "PERFIL",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                  color: Color(0xFFF7ECE1),
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
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Perfil del usuario
            _buildEnhancedProfileCard(),

            const SizedBox(height: 25),

            // Detalles del perfil
            _buildEnhancedDetailsCard(),

            const SizedBox(height: 25),

            // Estadísticas de entrenamiento (NUEVO COMPONENTE)
            const WorkoutStatsWidget(),

            const SizedBox(height: 25),

            // Opciones adicionales
            _buildEnhancedOptionsCard(),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
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
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar del usuario con efecto resplandor
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF9067C6).withOpacity(0.7),
                  const Color(0xFF725AC1).withOpacity(0.5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9067C6).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 4,
              ),
            ),
            child: const Center(
              child: Icon(
                Amicons.lucide_user_round_pen,
                color: Color(0xFFF7ECE1),
                size: 65,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Nombre del usuario
          Obx(() => Text(
                authController.userModel.value?.nombre ?? "Usuario",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 8),

          // Email del usuario
          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  authController.userModel.value?.email ??
                      "Email no disponible",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFCAC4CE).withOpacity(0.9),
                  ),
                ),
              )),

          const SizedBox(height: 25),

          // Botón para editar perfil
          _buildEnhancedButton(
            "Editar perfil",
            () {
              Get.to(() => const EditProfilePage());
            },
            const Color(0xFF9067C6),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
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
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
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
                "Detalles personales",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8D86C9).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Amicons.remix_profile_fill,
                  color: Color(0xFFF7ECE1),
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          // Información detallada del usuario

          Obx(() => _buildEnhancedInfoRow(
                Amicons.remix_line_height,
                "Altura",
                "${authController.userModel.value?.altura.toString() ?? '0'} cm",
              )),

          const SizedBox(height: 15),

          Obx(() => _buildEnhancedInfoRow(
                Amicons.flaticon_rings_wedding_rounded_fill,
                "Peso",
                "${authController.userModel.value?.peso.toString() ?? '0'} kg",
              )),

          const SizedBox(height: 15),

          Obx(() => _buildEnhancedInfoRow(
                Amicons.lucide_dumbbell,
                "Nivel de experiencia",
                authController.userModel.value?.nivelExperiencia ??
                    "Sin información",
              )),

          const SizedBox(height: 15),

          Obx(() => _buildEnhancedInfoRow(
                Amicons.flaticon_gym_rounded_fill,
                "Objetivo principal",
                authController.userModel.value?.objetivo ?? "Sin información",
              )),
        ],
      ),
    );
  }

  Widget _buildEnhancedOptionsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
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
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 8),
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
                "Opciones adicionales",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8D86C9).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Amicons.iconly_more_circle_fill,
                  color: Color(0xFFF7ECE1),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildEnhancedOptionButton(
            "Historial de entrenamientos",
            Amicons.remix_history,
            Colors.teal,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WorkoutHistoryPage()),
              );
            },
          ),
          const SizedBox(height: 15),
          _buildEnhancedOptionButton(
            "Medidas corporales",
            Amicons.remix_body_scan,
            Colors.deepPurple,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BMICalculatorPage()),
              );
            },
          ),
          const SizedBox(height: 15),
          _buildEnhancedOptionButton(
            "Cerrar sesión",
            Amicons.iconly_logout_curved,
            Colors.redAccent,
            () {
              authController.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedOptionButton(
      String text, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                color.withOpacity(0.7),
                color.withOpacity(0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(
                Amicons.iconly_arrow_right_curved_fill,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
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

  Widget _buildEnhancedButton(
      String text, VoidCallback onPressed, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                color,
                Color.lerp(color, Colors.deepPurple, 0.3) ?? color,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
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
                  Amicons.iconly_edit_curved_fill,
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
}
