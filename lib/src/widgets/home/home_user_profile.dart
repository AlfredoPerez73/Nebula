import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/controllers/user.controller.dart';
import 'package:nebula/src/utils/app_color.dart';
import 'package:nebula/src/views/pages/editProfilePageSkills.dart';
import 'dart:ui';

class HomeUserProfile extends StatelessWidget {
  final AuthController authController;

  const HomeUserProfile({
    Key? key,
    required this.authController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration:
          AppColors.glassCardDecoration(borderColor: AppColors.accentColor),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: AppColors.accentColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "TU PERFIL",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentColor,
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
                      ],
                    ),
                    _buildProfileActionButton(
                      icon: Icons.edit_rounded,
                      onTap: () => Get.to(() => const EditProfilePageSkills()),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // User Info
                Obx(() {
                  final userName =
                      authController.userModel.value?.nombre ?? "Usuario";
                  final userInitial = userName.isNotEmpty
                      ? userName.substring(0, 1).toUpperCase()
                      : "U";

                  return Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryColor,
                              AppColors.secondaryColor,
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            userInitial,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authController.userModel.value?.nombre ??
                                  "Usuario",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              authController.userModel.value?.email ??
                                  "email@ejemplo.com",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                authController
                                        .userModel.value?.nivelExperiencia ??
                                    "Principiante",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 24),

                // Stats Grid - MODIFICADO para ser simétrico
                Obx(() {
                  // Datos del perfil
                  final objetivo =
                      authController.userModel.value?.objetivo ?? "Sin definir";
                  final peso =
                      "${authController.userModel.value?.peso ?? 0} kg";
                  final altura =
                      "${authController.userModel.value?.altura ?? 0} cm";
                  final imc = _calculateBMI().toStringAsFixed(1);

                  return GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.1, // Proporciones cuadradas
                    children: [
                      _buildSymmetricalStatCard(
                        title: "Objetivo",
                        value: objetivo,
                        icon: Icons.fitness_center_rounded,
                      ),
                      _buildSymmetricalStatCard(
                        title: "Peso",
                        value: peso,
                        icon: Icons.monitor_weight_rounded,
                      ),
                      _buildSymmetricalStatCard(
                        title: "Altura",
                        value: altura,
                        icon: Icons.height_rounded,
                      ),
                      _buildSymmetricalStatCard(
                        title: "IMC",
                        value: imc,
                        icon: Icons.speed_rounded,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateBMI() {
    double? altura = authController.userModel.value?.altura;
    double? peso = authController.userModel.value?.peso;

    if (altura != null && peso != null && altura > 0) {
      return peso / ((altura / 100) * (altura / 100));
    }
    return 0.0;
  }

  Widget _buildProfileActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.accentColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.accentColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  // Nuevo método para tarjetas de estadísticas simétricas
  Widget _buildSymmetricalStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // Título
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),

          // Fila de icono y valor
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icono a la izquierda
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Valor con tamaño flexible
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
