import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/controllers/user.controller.dart';
import 'package:nebula/src/controllers/training.controller.dart';
import 'package:nebula/src/utils/app_color.dart';

class HomeProgressStats extends StatelessWidget {
  final AuthController authController;
  final EntrenamientoController entrenamientoController;

  const HomeProgressStats({
    Key? key,
    required this.authController,
    required this.entrenamientoController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondaryColor.withOpacity(0.9),
            AppColors.darkPurple.withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.trending_up_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "PROGRESO",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Obx(() => Text(
                              authController.userModel.value?.nivelExperiencia
                                      ?.toUpperCase() ??
                                  "PRINCIPIANTE",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Monitorea tus avances de entrenamiento y logros",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Stats Cards Grid
            Padding(
              padding: const EdgeInsets.all(24),
              child: GetBuilder<EntrenamientoController>(builder: (controller) {
                // Calcular estadísticas basadas en datos reales
                int totalSesiones = 0;
                int totalMinutos = 0;
                int totalCalorias = 0;
                int totalLogros = 0;
                int maxLogros = 0;
                String nivelExperiencia = authController
                        .userModel.value?.nivelExperiencia
                        ?.toLowerCase() ??
                    "principiante";

                // Determinar metas según nivel de experiencia
                int metaSesiones = _getMetaSesiones(nivelExperiencia);
                int metaMinutos = _getMetaMinutos(nivelExperiencia);
                int metaCalorias = _getMetaCalorias(nivelExperiencia,
                    authController.userModel.value?.peso ?? 70);

                if (controller.entrenamientos.isNotEmpty) {
                  // Contar días únicos de entrenamiento para las sesiones
                  Set<String> diasUnicos = {};

                  for (var entrenamiento in controller.entrenamientos) {
                    for (var ejercicio in entrenamiento.ejercicios) {
                      diasUnicos.add(ejercicio.dia.toLowerCase());

                      // Calcular tiempo aproximado por ejercicio (series * repeticiones * tiempo promedio)
                      int tiempoEjercicio = ejercicio.series *
                          int.parse(ejercicio.repeticiones) *
                          1 ~/
                          1;
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

                  totalLogros =
                      logrosCompletados.where((logro) => logro).length;
                }

                // Paleta de colores para las tarjetas
                final List<Color> cardColors = [
                  AppColors.primaryColor,
                  const Color(0xFF8E44AD),
                  const Color(0xFF9B59B6),
                  const Color(0xFFAF7AC5),
                ];

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: "Sesiones",
                            value: totalSesiones,
                            target: metaSesiones,
                            icon: Icons.calendar_today_rounded,
                            color: cardColors[0],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: "Minutos",
                            value: totalMinutos,
                            target: metaMinutos,
                            icon: Icons.timer_rounded,
                            color: cardColors[1],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: "Calorías",
                            value: totalCalorias,
                            target: metaCalorias,
                            icon: Icons.local_fire_department_rounded,
                            color: cardColors[2],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: "Logros",
                            value: totalLogros,
                            target: maxLogros,
                            icon: Icons.emoji_events_rounded,
                            color: cardColors[3],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int value,
    required int target,
    required IconData icon,
    required Color color,
  }) {
    final double progress = (value / target).clamp(0.0, 1.0);
    final bool isComplete = progress >= 1.0;
    final Color accentColor = Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3.5,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: accentColor.withOpacity(0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isComplete
                      ? accentColor.withOpacity(0.25)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${(progress * 100).toInt()}%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accentColor.withOpacity(isComplete ? 1.0 : 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "/ $target",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: accentColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares para calcular metas según nivel de experiencia

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
}
