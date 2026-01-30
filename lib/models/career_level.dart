import 'package:flutter/material.dart';

/// Modelo de nível da carreira médica (15 níveis fixos).
/// Cada nível pertence a uma categoria (Internato, Residente, etc.) e um tier (I, II, III).
class CareerLevel {
  final int levelIndex;
  final String categoryName;
  final String tierLabel;
  final Color color;

  const CareerLevel({
    required this.levelIndex,
    required this.categoryName,
    required this.tierLabel,
    required this.color,
  });

  /// Label curto para exibição: "Residente II"
  String get displayName => '$categoryName $tierLabel';

  /// Índice da categoria (0 = Internato, 4 = Mentor)
  int get categoryIndex => levelIndex ~/ 3;

  /// Índice do tier dentro da categoria (0, 1, 2)
  int get tierIndex => levelIndex % 3;

  static const int pointsPerTier = 100;
  static const int totalLevels = 15;

  /// Lista fixa dos 15 níveis da carreira
  static const List<CareerLevel> allLevels = [
    CareerLevel(levelIndex: 0, categoryName: 'Internato', tierLabel: 'I', color: Color(0xFF81C784)),
    CareerLevel(levelIndex: 1, categoryName: 'Internato', tierLabel: 'II', color: Color(0xFF66BB6A)),
    CareerLevel(levelIndex: 2, categoryName: 'Internato', tierLabel: 'III', color: Color(0xFF4CAF50)),
    CareerLevel(levelIndex: 3, categoryName: 'Residente', tierLabel: 'I', color: Color(0xFF64B5F6)),
    CareerLevel(levelIndex: 4, categoryName: 'Residente', tierLabel: 'II', color: Color(0xFF42A5F5)),
    CareerLevel(levelIndex: 5, categoryName: 'Residente', tierLabel: 'III', color: Color(0xFF2196F3)),
    CareerLevel(levelIndex: 6, categoryName: 'Staff', tierLabel: 'I', color: Color(0xFFBA68C8)),
    CareerLevel(levelIndex: 7, categoryName: 'Staff', tierLabel: 'II', color: Color(0xFFAB47BC)),
    CareerLevel(levelIndex: 8, categoryName: 'Staff', tierLabel: 'III', color: Color(0xFF9C27B0)),
    CareerLevel(levelIndex: 9, categoryName: 'Especialista', tierLabel: 'I', color: Color(0xFFFFB74D)),
    CareerLevel(levelIndex: 10, categoryName: 'Especialista', tierLabel: 'II', color: Color(0xFFFFA726)),
    CareerLevel(levelIndex: 11, categoryName: 'Especialista', tierLabel: 'III', color: Color(0xFFFF9800)),
    CareerLevel(levelIndex: 12, categoryName: 'Mentor', tierLabel: 'I', color: Color(0xFF78909C)),
    CareerLevel(levelIndex: 13, categoryName: 'Mentor', tierLabel: 'II', color: Color(0xFF607D8B)),
    CareerLevel(levelIndex: 14, categoryName: 'Mentor', tierLabel: 'III', color: Color(0xFF455A64)),
  ];

  static CareerLevel at(int levelIndex) {
    if (levelIndex < 0 || levelIndex >= totalLevels) {
      return allLevels[levelIndex.clamp(0, totalLevels - 1)];
    }
    return allLevels[levelIndex];
  }

  /// Último nível (Mentor III)
  static CareerLevel get maxLevel => allLevels[totalLevels - 1];

  bool get isMaxLevel => levelIndex >= totalLevels - 1;
}
