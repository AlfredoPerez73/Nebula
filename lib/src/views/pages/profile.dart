import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/views/pages/edit_profile.dart';
import '../../controllers/user.controller.dart';
import 'package:amicons/amicons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  int _selectedIndex = 3; // Perfil seleccionado

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
          child: Column(
            children: [
              // Appbar personalizada
              _buildCustomAppBar(),

              // Contenido principal
              Expanded(
                child: _buildMainContent(),
              ),
            ],
          ),
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
                  Amicons.lucide_user_round_cog,
                  color: Color(0xFFF7ECE1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "PERFIL",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Color(0xFFF7ECE1),
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
            _buildUserProfileCard(),

            const SizedBox(height: 20),

            // Detalles del perfil
            _buildProfileDetailsCard(),

            const SizedBox(height: 20),

            // Estadísticas del usuario
            _buildUserStatsCard(),

            const SizedBox(height: 20),

            // Preferencias del usuario
            _buildUserPreferencesCard(),

            const SizedBox(height: 20),

            // Progreso del usuario
            _buildUserProgressCard(),

            const SizedBox(height: 20),

            // Opciones adicionales
            _buildAdditionalOptionsCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileCard() {
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
        children: [
          // Avatar del usuario
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF9067C6).withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 3,
              ),
            ),
            child: const Center(
              child: Icon(
                Amicons.lucide_user_round_pen,
                color: Color(0xFFF7ECE1),
                size: 60,
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Nombre del usuario
          Obx(() => Text(
                authController.userModel.value?.nombre ?? "Usuario",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7ECE1),
                ),
              )),

          const SizedBox(height: 5),

          // Email del usuario
          Obx(() => Text(
                authController.userModel.value?.email ?? "Email no disponible",
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFFCAC4CE).withOpacity(0.8),
                ),
              )),

          const SizedBox(height: 20),

          // Botón para editar perfil
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => const EditProfilePage());
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: const Color(0xFF9067C6),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Editar perfil"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailsCard() {
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
            "Detalles personales",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),

          const SizedBox(height: 15),
          // Información detallada del usuario

          Obx(() => _buildInfoRow(
                Amicons.lucide_dumbbell,
                "Altura",
                "${authController.userModel.value?.altura.toString() ?? '0'} cm",
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
                "Nivel de experiencia",
                authController.userModel.value?.nivelExperiencia ??
                    "Sin información",
              )),

          const SizedBox(height: 10),

          Obx(() => _buildInfoRow(
                Amicons.flaticon_gym_rounded_fill,
                "Objetivo principal",
                authController.userModel.value?.objetivo ?? "Sin información",
              )),
        ],
      ),
    );
  }

  Widget _buildUserStatsCard() {
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
            "Estadísticas",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "Sesiones",
                  "27",
                  Amicons.iconly_calendar_broken,
                  Colors.blue.withOpacity(0.4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  "Minutos",
                  "840",
                  Amicons.iconly_time_circle_broken,
                  Colors.green.withOpacity(0.4),
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
                  Colors.orange.withOpacity(0.4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  "Logros",
                  "5",
                  Amicons.vuesax_archive_minus,
                  Colors.purple.withOpacity(0.4),
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

  Widget _buildUserPreferencesCard() {
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
            "Preferencias de entrenamiento",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),
          const SizedBox(height: 15),
          _buildPreferenceItem("Duración preferida", "30-45 minutos"),
          const SizedBox(height: 10),
          _buildPreferenceItem("Días de entrenamiento", "Lun, Mié, Vie"),
          const SizedBox(height: 10),
          _buildPreferenceItem("Área favorita", "Tren superior"),
          const SizedBox(height: 10),
          _buildPreferenceItem("Equipamiento disponible", "Mancuernas, Bandas"),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Implementar navegación a la pantalla de edición de preferencias
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: const Color(0xFF9067C6),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Editar preferencias"),
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
            "Tu progreso",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),

          const SizedBox(height: 15),

          // Progreso de peso
          _buildProgressItem(
            "Peso",
            "75 kg",
            "-2.5 kg",
            0.7,
            Colors.cyan,
          ),

          const SizedBox(height: 15),

          // Progreso de fuerza
          _buildProgressItem(
            "Fuerza",
            "Press de banca",
            "+10 kg",
            0.6,
            Colors.amber,
          ),

          const SizedBox(height: 15),

          // Progreso de resistencia
          _buildProgressItem(
            "Resistencia",
            "30 min. cardio",
            "+8 min.",
            0.8,
            Colors.greenAccent,
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Implementar navegación a la pantalla de progreso detallado
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: const Color(0xFF9067C6),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Ver progreso detallado"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
      String title, String value, String change, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF7ECE1),
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
    );
  }

  Widget _buildAdditionalOptionsCard() {
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
            "Opciones adicionales",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF7ECE1),
            ),
          ),
          const SizedBox(height: 15),
          _buildOptionButton(
            "Historial de entrenamientos",
            Amicons.remix_history,
            Colors.teal.withOpacity(0.4),
            () {
              // Implementar navegación al historial de entrenamientos
            },
          ),
          const SizedBox(height: 10),
          _buildOptionButton(
            "Medidas corporales",
            Amicons.remix_body_scan,
            Colors.deepPurple.withOpacity(0.4),
            () {
              // Implementar navegación a medidas corporales
            },
          ),
          const SizedBox(height: 10),
          _buildOptionButton(
            "Cerrar sesión",
            Amicons.iconly_logout_curved,
            Colors.redAccent.withOpacity(0.4),
            () {
              authController.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
      String text, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 15),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: const Color(0xFFCAC4CE).withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFF7ECE1),
          ),
        ),
      ],
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
}
