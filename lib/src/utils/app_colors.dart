import 'package:flutter/material.dart';

class AppColors {
  static const oscureColor = Color(0xFF103558);
  static const greenOscure = Color(0xFF205A6D);
  static const fondoColors = Color(0xFF015450);
  static const greenLight = Color(0xFF008186);
  static const greenAcents = Color(0xFF53E39C);
  static const greenAcents2 = Color(0xFF53639C);
  static const colorwhite = Color(0xFFF3F7E0);
  static const headerColor = Color(0xFFF2F6DF);
  static const greyColor = Color(0xFF829788);

  static const gradientColor1 = LinearGradient(
    colors: [
      greenAcents,
      greenAcents2,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const gradientColor2 = LinearGradient(
      colors: [
        greyColor,
        colorwhite,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.5, 0.5]);
}
