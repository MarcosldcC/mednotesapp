import 'package:flutter/material.dart';
import 'career_level.dart';

/// Modelo de Tier do sistema de progresso.
/// Preferir [CareerLevel] para o novo sistema de carreira (15 níveis, 100 pts/tier).
@Deprecated('Use CareerLevel e CareerProgressService para o sistema de carreira médica')
class Tier {
  final String name;
  final int minExp;
  final int maxExp;
  final Color color;

  const Tier({
    required this.name,
    required this.minExp,
    required this.maxExp,
    required this.color,
  });

  /// Cria um Tier a partir de um CareerLevel (compatibilidade).
  static Tier fromCareerLevel(CareerLevel level) {
    return Tier(
      name: level.displayName,
      minExp: level.levelIndex * CareerLevel.pointsPerTier,
      maxExp: level.levelIndex * CareerLevel.pointsPerTier + CareerLevel.pointsPerTier - 1,
      color: level.color,
    );
  }

  /// Lista padrão de tiers do sistema (legado)
  static const List<Tier> defaultTiers = [
    Tier(name: 'Bronze', minExp: 0, maxExp: 999, color: Color(0xFF8D6E63)),
    Tier(name: 'Prata', minExp: 1000, maxExp: 2999, color: Color(0xFF9E9E9E)),
    Tier(name: 'Ouro', minExp: 3000, maxExp: 5999, color: Color(0xFFF4B400)),
    Tier(name: 'Platina', minExp: 6000, maxExp: 9999, color: Color(0xFF4FC3F7)),
    Tier(name: 'Diamante', minExp: 10000, maxExp: 999999, color: Color(0xFF7E57C2)),
  ];

  /// Retorna o label do tier (primeira letra)
  String get label => name.substring(0, 1).toUpperCase();
}
