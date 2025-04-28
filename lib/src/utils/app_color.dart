import 'package:flutter/material.dart';

/// Clase que centraliza los colores y estilos visuales de la aplicación
class AppColors {
  // Colores principales
  static const Color backgroundColor = Color(0xFF242038);
  static const Color primaryColor = Color(0xFF9067C6);
  static const Color accentColor = Color(0xFFF7ECE1);
  static const Color secondaryColor = Color(0xFF8D86C9);
  static const Color darkPurple = Color(0xFF4A366A);
  static const Color lightPurple = Color(0xFFB39DDB);

  // Categorías IMC
  static const Color bmiUnderweight = Color(0xFF3498DB); // Azul
  static const Color bmiNormal = Color(0xFF2ECC71); // Verde
  static const Color bmiOverweight = Color(0xFFE67E22); // Naranja
  static const Color bmiObese = Color(0xFFE74C3C); // Rojo

  // Gradientes
  static final Gradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      backgroundColor,
      Color.lerp(backgroundColor, primaryColor, 0.4) ??
          primaryColor.withOpacity(0.8),
      primaryColor.withOpacity(0.8),
    ],
    stops: const [0.2, 0.6, 1.0],
  );

  static final Gradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      secondaryColor,
      darkPurple,
    ],
  );

  static final Gradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      primaryColor,
      Color.lerp(primaryColor, darkPurple, 0.3) ?? primaryColor,
    ],
  );

  // Sombras comunes
  static final BoxShadow primaryShadow = BoxShadow(
    color: primaryColor.withOpacity(0.25),
    blurRadius: 15,
    spreadRadius: 1,
    offset: const Offset(0, 8),
  );

  static final BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.12),
    blurRadius: 12,
    spreadRadius: 0,
    offset: const Offset(0, 6),
  );

  // Decoraciones comunes
  static BoxDecoration glassCardDecoration(
      {Color? borderColor, double opacity = 0.1}) {
    final Color accent = borderColor ?? Colors.white;

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(
        color: accent.withOpacity(0.2),
        width: 1.5,
      ),
      boxShadow: [cardShadow],
    );
  }

  static BoxDecoration solidCardDecoration(
      {required Color color,
      Color? secondaryColor,
      double opacity = 0.9,
      double radius = 28}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(opacity),
          secondaryColor?.withOpacity(opacity) ??
              color.withOpacity(opacity * 0.8),
        ],
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [cardShadow],
    );
  }

  // Estilos de texto
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
    letterSpacing: 0.3,
  );

  static const TextStyle statValueStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle statLabelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white.withOpacity(0.7),
  );
}
