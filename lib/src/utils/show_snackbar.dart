import 'package:flutter/material.dart';
import 'package:nebula/src/utils/app_colors.dart';

void showSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.oscureColor,
      content: Text(
        content,
        style: const TextStyle(
          color: AppColors.colorwhite,
          fontFamily: "MonB",
        ),
      ),
    ),
  );
}
