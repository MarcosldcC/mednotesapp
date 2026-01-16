import 'package:flutter/material.dart';
import 'colors.dart' as colors;

class AppTextStyles {
  // Títulos principais
  static TextStyle get heading1 => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: colors.AppColors.darkGreenText,
    letterSpacing: -0.5,
  );
  
  static TextStyle get heading2 => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: colors.AppColors.darkGreenText,
    letterSpacing: -0.3,
  );
  
  static TextStyle get heading3 => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: colors.AppColors.darkGreenText,
    letterSpacing: -0.2,
  );
  
  // Texto de corpo
  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: colors.AppColors.mediumGreen,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: colors.AppColors.mediumGreen,
    height: 1.4,
  );
  
  static TextStyle? get bodySmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: colors.AppColors.mediumGreen,
    height: 1.3,
  );
  
  // Labels de formulário
  static TextStyle get label => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: colors.AppColors.darkGreenText,
  );
  
  // Botões
  static TextStyle get button => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: colors.AppColors.white,
    letterSpacing: 0.5,
  );
  
  // Links
  static TextStyle get link => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: colors.AppColors.lightGreen,
    decoration: TextDecoration.underline,
  );
  
  // Texto secundário
  static TextStyle get secondaryText => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: colors.AppColors.grayText,
  );
}
