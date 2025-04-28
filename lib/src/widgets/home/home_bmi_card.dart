import 'package:flutter/material.dart';
import 'package:nebula/src/controllers/user.controller.dart';
import 'package:nebula/src/utils/app_color.dart';
import 'package:nebula/src/utils/ui_helpers.dart';
import 'package:nebula/src/views/pages/iMCCalculatorPage.dart';

class HomeBmiCard extends StatelessWidget {
  final AuthController authController;

  const HomeBmiCard({
    Key? key,
    required this.authController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla para hacer cálculos responsivos
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    double bmi = _calculateBMI();
    String bmiCategory = _getBMICategory(bmi);
    Color categoryColor = _getBMICategoryColor(bmiCategory);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Fondo con patrón sutil
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                ),
                child: CustomPaint(
                  painter: PatternPainter(
                    color: categoryColor.withOpacity(0.1),
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header - Ahora con padding adaptable según tamaño de pantalla
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16 : 24,
                      vertical: isSmallScreen ? 20 : 28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        categoryColor,
                        _getGradientSecondaryColor(categoryColor),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Título con tamaño adaptable
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.all(isSmallScreen ? 8 : 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.insert_chart_rounded,
                                    color: Colors.white,
                                    size: isSmallScreen ? 18 : 22,
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 10 : 14),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ÍNDICE DE",
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 10 : 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                                      SizedBox(height: isSmallScreen ? 1 : 2),
                                      Text(
                                        "MASA CORPORAL",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 16 : 20,
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
                          // Etiqueta de categoría
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 10 : 14,
                                vertical: isSmallScreen ? 4 : 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              bmiCategory,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 16 : 24),
                      // Estadísticas del IMC con tamaño adaptable
                      Row(
                        children: [
                          _buildBMIStat(
                            context: context,
                            label: "Tu IMC",
                            value: bmi.toStringAsFixed(1),
                            iconData: Icons.speed_rounded,
                          ),
                          SizedBox(width: isSmallScreen ? 16 : 24),
                          _buildBMIStat(
                            context: context,
                            label: "Peso actual",
                            value:
                                "${authController.userModel.value?.peso ?? 0} kg",
                            iconData: Icons.monitor_weight_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Body Content - Adaptable
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        categoryColor.withOpacity(0.2),
                        categoryColor.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BMI Scale Visualization - Altura adaptable
                      Container(
                        height: isSmallScreen ? 50 : 60,
                        margin:
                            EdgeInsets.only(bottom: isSmallScreen ? 16 : 24),
                        child: _buildBMIScale(context, bmi),
                      ),

                      // Health Tip - Tamaño adaptable
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: categoryColor.withOpacity(0.15),
                              blurRadius: 12,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.lightbulb_outline_rounded,
                                color: categoryColor,
                                size: isSmallScreen ? 20 : 24,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 12 : 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Consejo de salud",
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: categoryColor,
                                    ),
                                  ),
                                  SizedBox(height: isSmallScreen ? 6 : 8),
                                  Text(
                                    _getBMIHealthTip(
                                        bmiCategory, isSmallScreen),
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 12 : 14,
                                      color: Colors.black.withOpacity(0.7),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 24),
                      _buildActionButton(
                        context: context,
                        text: "Más información",
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BMICalculatorPage()),
                          );
                        },
                        color: categoryColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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

  Widget _buildBMIStat({
    required BuildContext context,
    required String label,
    required String value,
    required IconData iconData,
  }) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: Colors.white,
              size: isSmallScreen ? 16 : 20,
            ),
          ),
          SizedBox(width: isSmallScreen ? 10 : 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: isSmallScreen ? 2 : 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBMIScale(BuildContext context, double bmi) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 360;
    final double scaleWidth = MediaQuery.of(context).size.width -
        (isSmallScreen ? 32 : 48); // Ajustar al padding

    // BMI Range colors
    const Color underweightColor = AppColors.bmiUnderweight;
    const Color normalColor = AppColors.bmiNormal;
    const Color overweightColor = AppColors.bmiOverweight;
    const Color obeseColor = AppColors.bmiObese;

    // Calculate position percentage (0-100%)
    double positionPercent = 0;
    if (bmi <= 15) {
      positionPercent = 0;
    } else if (bmi >= 40) {
      positionPercent = 100;
    } else {
      positionPercent =
          ((bmi - 15) / 25) * 100; // Range from 15-40 mapped to 0-100%
    }

    // Calcular la posición real en pixeles basado en el ancho disponible
    final double indicatorPosition =
        (positionPercent.clamp(0, 100) * scaleWidth / 100);

    return Stack(
      children: [
        // Background scale
        Container(
          height: 8, // Más delgado en pantallas pequeñas
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                underweightColor,
                normalColor,
                overweightColor,
                obeseColor,
              ],
              stops: [0.14, 0.4, 0.6, 1.0], // Adjusted for BMI ranges
            ),
          ),
        ),

        // Indicator - Ahora con posición calculada directamente
        Positioned(
          left: indicatorPosition.clamp(0, scaleWidth) -
              (isSmallScreen ? 10 : 13), // Centrar el indicador
          top: isSmallScreen ? -6 : -8,
          child: Container(
            width: isSmallScreen ? 20 : 26,
            height: isSmallScreen ? 20 : 26,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: _getBMICategoryColor(_getBMICategory(bmi)),
                width: isSmallScreen ? 2 : 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),

        // Range labels con tamaño adaptable
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBMIRangeLabel(context, "Bajo", underweightColor),
              _buildBMIRangeLabel(context, "Normal", normalColor),
              _buildBMIRangeLabel(context, "Sobrepeso", overweightColor),
              _buildBMIRangeLabel(context, "Obesidad", obeseColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBMIRangeLabel(BuildContext context, String text, Color color) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 6 : 8, vertical: isSmallScreen ? 3 : 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isSmallScreen ? 8 : 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 12 : 16,
              horizontal: isSmallScreen ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                color,
                _getGradientSecondaryColor(color),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 10),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: isSmallScreen ? 16 : 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return "Bajo peso";
    if (bmi < 25) return "Peso normal";
    if (bmi < 30) return "Sobrepeso";
    return "Obesidad";
  }

  Color _getBMICategoryColor(String bmiCategory) {
    switch (bmiCategory) {
      case "Bajo peso":
        return AppColors.bmiUnderweight; // Azul
      case "Peso normal":
        return AppColors.bmiNormal; // Verde
      case "Sobrepeso":
        return AppColors.bmiOverweight; // Naranja
      case "Obesidad":
        return AppColors.bmiObese; // Rojo
      default:
        return AppColors.bmiNormal; // Verde por defecto
    }
  }

  Color _getGradientSecondaryColor(Color primaryColor) {
    // Oscurecer el color primario para el degradado
    HSLColor hslColor = HSLColor.fromColor(primaryColor);
    return hslColor
        .withLightness((hslColor.lightness - 0.15).clamp(0.0, 1.0))
        .toColor();
  }

  String _getBMIHealthTip(String bmiCategory, bool isSmallScreen) {
    // Versión más corta para pantallas pequeñas
    if (isSmallScreen) {
      switch (bmiCategory) {
        case "Bajo peso":
          return "Consulta a un nutricionista para un plan de alimentación que te ayude a ganar peso saludablemente.";
        case "Peso normal":
          return "¡Excelente! Mantén tu dieta equilibrada y ejercicio regular.";
        case "Sobrepeso":
          return "Reduce calorías moderadamente y aumenta la actividad física.";
        case "Obesidad":
          return "Consulta a un profesional para un plan integral de alimentación y ejercicio.";
        default:
          return "Consulta a un profesional para una evaluación personalizada.";
      }
    }

    // Versión completa para pantallas normales/grandes
    switch (bmiCategory) {
      case "Bajo peso":
        return "Considera consultar a un nutricionista para desarrollar un plan de alimentación equilibrado que te ayude a aumentar de peso de forma saludable.";
      case "Peso normal":
        return "¡Excelente! Mantén tu estilo de vida saludable con una dieta equilibrada y ejercicio regular para conservar tu peso ideal.";
      case "Sobrepeso":
        return "Enfócate en reducir moderadamente las calorías y aumentar la actividad física. Un déficit de 500 calorías diarias puede ayudarte a perder peso de forma saludable.";
      case "Obesidad":
        return "Es importante consultar con un profesional de la salud para desarrollar un plan integral que incluya cambios en la alimentación, actividad física y posiblemente apoyo psicológico.";
      default:
        return "Consulta a un profesional de salud para una evaluación personalizada de tu índice de masa corporal.";
    }
  }
}
