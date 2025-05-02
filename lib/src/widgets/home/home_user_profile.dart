import 'dart:ui';

import 'package:amicons/amicons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/controllers/user.controller.dart';
import 'package:nebula/src/utils/app_color.dart';
import 'package:nebula/src/views/pages/edit_profile_page_skills.dart';

class HomeUserProfile extends StatelessWidget {
  final AuthController authController;

  const HomeUserProfile({
    super.key,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    // Detectar si la pantalla es pequeña para ajustes responsivos
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration:
          AppColors.glassCardDecoration(borderColor: AppColors.accentColor),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: AppColors.accentColor,
                              size: isSmallScreen ? 18 : 22,
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Text(
                            "TU PERFIL",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentColor,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                  color: Colors.black.withValues(alpha: 0.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildProfileActionButton(
                      icon: Icons.edit_rounded,
                      onTap: () => Get.to(() => const EditProfilePageSkills()),
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),

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
                        width: isSmallScreen ? 50 : 64,
                        height: isSmallScreen ? 50 : 64,
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
                              color:
                                  AppColors.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            userInitial,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 22 : 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authController.userModel.value?.nombre ??
                                  "Usuario",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 18 : 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: isSmallScreen ? 2 : 4),
                            Text(
                              authController.userModel.value?.email ??
                                  "email@ejemplo.com",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: isSmallScreen ? 4 : 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 8 : 12,
                                  vertical: isSmallScreen ? 3 : 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                authController
                                        .userModel.value?.nivelExperiencia ??
                                    "Principiante",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 10 : 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),

                SizedBox(height: isSmallScreen ? 16 : 24),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF38295C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.dashboard_customize,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "DETALLES PERSONALES",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // NUEVA IMPLEMENTACIÓN: Stats Cards en una fila horizontal con scroll
                Obx(() {
                  // Datos del perfil
                  final objetivo =
                      authController.userModel.value?.objetivo ?? "Sin definir";
                  final peso =
                      "${authController.userModel.value?.peso ?? 0} kg";
                  final altura =
                      "${authController.userModel.value?.altura ?? 0} cm";
                  final nivelExperiencia =
                      authController.userModel.value?.nivelExperiencia ??
                          "Principiante";

                  // Configuración para las nuevas tarjetas verticales
                  final statCards = [
                    {
                      "title": "Altura",
                      "value": altura,
                      "icon": Amicons.lucide_arrow_up_down,
                    },
                    {
                      "title": "Peso",
                      "value": peso,
                      "icon": Amicons.vuesax_weight,
                    },
                    {
                      "title": "Nivel de experiencia",
                      "value": nivelExperiencia,
                      "icon": Amicons.remix_medal_fill,
                    },
                    {
                      "title": "Objetivo principal",
                      "value": objetivo,
                      "icon": Amicons.lucide_hand_metal,
                    },
                  ];

                  // Fila horizontal con scroll
                  return SizedBox(
                    height: 180, // Altura fija para las tarjetas
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: statCards.map((card) {
                          return Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: _buildVerticalCard(
                              title: card["title"] as String,
                              value: card["value"] as String,
                              icon: card["icon"] as IconData,
                              isSmallScreen: isSmallScreen,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Nuevo widget para tarjetas verticales con diseño profesional
  Widget _buildVerticalCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isSmallScreen,
  }) {
    // Colores profesionales
    final cardBgColor = Color(0xFF38295C);

    return Container(
      width: 130, // Ancho fijo para cada tarjeta
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icono
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Color(0xFFA29BFE),
                size: 22,
              ),
            ),

            SizedBox(height: 12),

            // Título
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 8),

            // Valor con texto grande
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Diseño refinado basado en la imagen de referenci

  // Método existente - MANTENIDO IGUAL
  Widget _buildProfileActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
          decoration: BoxDecoration(
            color: AppColors.accentColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.accentColor,
            size: isSmallScreen ? 16 : 20,
          ),
        ),
      ),
    );
  }
}
