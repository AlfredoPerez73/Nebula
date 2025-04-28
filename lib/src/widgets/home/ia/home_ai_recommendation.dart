import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nebula/src/controllers/user.controller.dart';
import 'package:nebula/src/utils/app_color.dart';
import 'package:nebula/src/utils/ui_helpers.dart';

class HomeAIRecommendation extends StatelessWidget {
  final AuthController authController;
  final VoidCallback showWorkoutSelector;

  const HomeAIRecommendation({
    Key? key,
    required this.authController,
    required this.showWorkoutSelector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: AppColors.solidCardDecoration(
        color: AppColors.secondaryColor,
        secondaryColor: AppColors.primaryColor,
      ),
      child: Column(
        children: [
          // Header with wave clip
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 45),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.darkPurple.withOpacity(0.9),
                    AppColors.primaryColor.withOpacity(0.9),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.psychology_rounded, // ícono de cerebro/IA
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "IA POWERED",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "ENTRENAMIENTO PERSONALIZADO",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      "Para tu nivel ${authController.userModel.value?.nivelExperiencia ?? 'principiante'} y tu objetivo de ${authController.userModel.value?.objetivo ?? 'mantenimiento'}, te recomendamos:",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    )),
                const SizedBox(height: 16),
                _buildTrainingRecommendations(),
                const SizedBox(height: 24),
                _buildPrimaryButton(
                  text: "Generar rutina personalizada",
                  icon: Icons.psychology_rounded,
                  onPressed: showWorkoutSelector,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingRecommendations() {
    // Lista personalizada de recomendaciones basadas en el nivel del usuario
    String nivelExperiencia =
        authController.userModel.value?.nivelExperiencia?.toLowerCase() ??
            "principiante";
    String objetivo = authController.userModel.value?.objetivo?.toLowerCase() ??
        "mantenimiento";

    List<Map<String, dynamic>> recommendations = [];

    // Recomendaciones según nivel y objetivo
    if (nivelExperiencia == "principiante") {
      if (objetivo == "pérdida de peso" || objetivo == "perder peso") {
        recommendations = [
          {'icon': Icons.favorite_rounded, 'text': 'Cardio 30 min, 3x semana'},
          {
            'icon': Icons.fitness_center_rounded,
            'text': 'Fuerza básica, 2x semana'
          },
        ];
      } else if (objetivo == "ganar músculo" || objetivo == "hipertrofia") {
        recommendations = [
          {
            'icon': Icons.fitness_center_rounded,
            'text': 'Entrenamiento compuesto, 3x semana'
          },
          {
            'icon': Icons.timer_rounded,
            'text': 'Descanso entre series: 60-90 seg'
          },
        ];
      } else {
        recommendations = [
          {
            'icon': Icons.trending_up_rounded,
            'text': 'Cardio moderado, 2x semana'
          },
          {
            'icon': Icons.fitness_center_rounded,
            'text': 'Ejercicios funcionales, 2x semana'
          },
        ];
      }
    } else if (nivelExperiencia == "intermedio") {
      if (objetivo == "pérdida de peso" || objetivo == "perder peso") {
        recommendations = [
          {'icon': Icons.favorite_rounded, 'text': 'HIIT 20 min, 3x semana'},
          {
            'icon': Icons.fitness_center_rounded,
            'text': 'Circuito de fuerza, 3x semana'
          },
        ];
      } else if (objetivo == "ganar músculo" || objetivo == "hipertrofia") {
        recommendations = [
          {
            'icon': Icons.fitness_center_rounded,
            'text': 'Rutina dividida, 4x semana'
          },
          {
            'icon': Icons.timer_rounded,
            'text': 'Progressive overload, 8-12 reps'
          },
        ];
      } else {
        recommendations = [
          {
            'icon': Icons.trending_up_rounded,
            'text': 'Cardio variado, 2-3x semana'
          },
          {
            'icon': Icons.fitness_center_rounded,
            'text': 'Entrenamiento mixto, 3x semana'
          },
        ];
      }
    } else {
      // Avanzado o experto
      if (objetivo == "pérdida de peso" || objetivo == "perder peso") {
        recommendations = [
          {'icon': Icons.favorite_rounded, 'text': 'HIIT avanzado + cardio'},
          {
            'icon': Icons.fitness_center_rounded,
            'text': 'Supersets y entrenamiento compuesto'
          },
        ];
      } else if (objetivo == "ganar músculo" || objetivo == "hipertrofia") {
        recommendations = [
          {
            'icon': Icons.fitness_center_rounded,
            'text': 'Split 5-6 días con periodización'
          },
          {
            'icon': Icons.timer_rounded,
            'text': 'Técnicas avanzadas: drop sets, etc.'
          },
        ];
      } else {
        recommendations = [
          {
            'icon': Icons.trending_up_rounded,
            'text': 'Entrenamiento mixto de alta intensidad'
          },
          {
            'icon': Icons.fitness_center_rounded,
            'text': 'Periodización ondulante, 4-5x semana'
          },
        ];
      }
    }

    return Column(
      children: recommendations.map((rec) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  rec['icon'],
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  rec['text'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.white.withOpacity(0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.darkPurple,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
