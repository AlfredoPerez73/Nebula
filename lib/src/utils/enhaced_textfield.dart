import 'package:flutter/material.dart';

class EnhancedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final Color? primaryColor;
  final Color? secondaryColor;
  final TextStyle bodyStyle;
  final ColorScheme colorScheme;

  const EnhancedTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.keyboardType,
    required this.bodyStyle,
    required this.colorScheme,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = secondaryColor != null
        ? secondaryColor!.withValues(alpha: 0.2)
        : colorScheme.primary.withValues(alpha: 0.2);

    final Color iconColor = secondaryColor ?? colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: bodyStyle.copyWith(
          color: colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: InputBorder.none,
          labelText: label,
          labelStyle: bodyStyle.copyWith(
            color: colorScheme.onSurface,
            fontSize: 16,
          ),
          hintText: hint,
          hintStyle: bodyStyle.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 15,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
