import 'package:flutter/material.dart';

/// Estilo de ícone por categoria
enum CareerIconStyle {
  outline,
  semiFill,
  solid,
}

/// Tema visual por categoria da carreira (mesmo layout, personalidade diferente)
class CareerThemeData {
  final Color primaryColor;
  final Color secondaryColor;
  final double spacingMultiplier;
  final CareerIconStyle iconStyle;
  final Duration animationDuration;
  final bool showExplanatoryFeedback;
  final bool denseCards;
  final bool minimalAnimations;
  final bool monochrome;

  const CareerThemeData({
    required this.primaryColor,
    required this.secondaryColor,
    this.spacingMultiplier = 1.0,
    this.iconStyle = CareerIconStyle.outline,
    this.animationDuration = const Duration(milliseconds: 400),
    this.showExplanatoryFeedback = true,
    this.denseCards = false,
    this.minimalAnimations = false,
    this.monochrome = false,
  });
}

/// Temas por categoria (índice 0 = Internato, 4 = Mentor)
class CareerTheme {
  /// Internato: apoio, aprendizado, segurança
  static const CareerThemeData internato = CareerThemeData(
    primaryColor: Color(0xFF66BB6A),
    secondaryColor: Color(0xFF81C784),
    spacingMultiplier: 1.15,
    iconStyle: CareerIconStyle.outline,
    animationDuration: Duration(milliseconds: 500),
    showExplanatoryFeedback: true,
    denseCards: false,
    minimalAnimations: false,
    monochrome: false,
  );

  /// Residente: pressão, decisão, agilidade
  static const CareerThemeData residente = CareerThemeData(
    primaryColor: Color(0xFF2196F3),
    secondaryColor: Color(0xFF42A5F5),
    spacingMultiplier: 0.95,
    iconStyle: CareerIconStyle.semiFill,
    animationDuration: Duration(milliseconds: 280),
    showExplanatoryFeedback: false,
    denseCards: false,
    minimalAnimations: false,
    monochrome: false,
  );

  /// Staff: autonomia, precisão
  static const CareerThemeData staff = CareerThemeData(
    primaryColor: Color(0xFF9C27B0),
    secondaryColor: Color(0xFFAB47BC),
    spacingMultiplier: 1.0,
    iconStyle: CareerIconStyle.solid,
    animationDuration: Duration(milliseconds: 250),
    showExplanatoryFeedback: false,
    denseCards: false,
    minimalAnimations: true,
    monochrome: false,
  );

  /// Especialista: complexidade e síntese
  static const CareerThemeData especialista = CareerThemeData(
    primaryColor: Color(0xFFFF9800),
    secondaryColor: Color(0xFFFFA726),
    spacingMultiplier: 0.9,
    iconStyle: CareerIconStyle.solid,
    animationDuration: Duration(milliseconds: 200),
    showExplanatoryFeedback: false,
    denseCards: true,
    minimalAnimations: true,
    monochrome: false,
  );

  /// Mentor: autoridade máxima
  static const CareerThemeData mentor = CareerThemeData(
    primaryColor: Color(0xFF455A64),
    secondaryColor: Color(0xFF607D8B),
    spacingMultiplier: 0.85,
    iconStyle: CareerIconStyle.solid,
    animationDuration: Duration(milliseconds: 150),
    showExplanatoryFeedback: false,
    denseCards: true,
    minimalAnimations: true,
    monochrome: true,
  );

  static const List<CareerThemeData> byCategoryIndex = [
    internato,
    residente,
    staff,
    especialista,
    mentor,
  ];

  static CareerThemeData forLevelIndex(int levelIndex) {
    final categoryIndex = (levelIndex ~/ 3).clamp(0, 4);
    return byCategoryIndex[categoryIndex];
  }
}
