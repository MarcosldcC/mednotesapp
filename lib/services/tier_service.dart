import 'package:flutter/material.dart';
import '../models/tier.dart';
import '../models/career_level.dart';

/// Service para gerenciar informações de tier e progresso do usuário.
/// Para o novo sistema de carreira (15 níveis, 100 pts/tier), use [CareerProgressService] e [CareerLevel].
class TierService {
  /// Lista de tiers disponíveis
  final List<Tier> tiers;

  TierService({List<Tier>? tiers}) 
      : tiers = tiers ?? Tier.defaultTiers;

  /// Obtém o tier atual baseado na experiência do usuário
  Tier getCurrentTier(int userExp) {
    return tiers.lastWhere(
      (tier) => userExp >= tier.minExp && userExp <= tier.maxExp,
      orElse: () => tiers.first,
    );
  }

  /// Obtém o índice do tier atual
  int getCurrentTierIndex(int userExp) {
    final current = getCurrentTier(userExp);
    return tiers.indexOf(current);
  }

  /// Obtém o próximo tier
  Tier? getNextTier(int userExp) {
    final index = getCurrentTierIndex(userExp);
    if (index < 0 || index >= tiers.length - 1) return null;
    return tiers[index + 1];
  }

  /// Obtém a experiência alvo para o próximo tier
  int getTargetExp(int userExp) {
    final next = getNextTier(userExp);
    if (next == null) return userExp;
    return next.minExp;
  }

  /// Calcula a experiência necessária para o próximo tier
  int getExpToNextTier(int userExp) {
    final next = getNextTier(userExp);
    if (next == null) return 0;
    return (next.minExp - userExp).clamp(0, next.minExp);
  }

  /// Calcula o progresso dentro do tier atual (0.0 a 1.0)
  double getTierProgress(int userExp) {
    final current = getCurrentTier(userExp);
    final next = getNextTier(userExp);
    if (next == null) return 1.0;
    final range = next.minExp - current.minExp;
    if (range <= 0) return 1.0;
    return ((userExp - current.minExp) / range).clamp(0.0, 1.0);
  }

  /// Retorna a lista de conquistas de tier alcançadas
  List<String> getTierAchievements(int userExp) {
    final currentIndex = getCurrentTierIndex(userExp);
    if (currentIndex < 0) return const [];
    return tiers
        .take(currentIndex + 1)
        .map((tier) => 'Tier ${tier.name} conquistado')
        .toList();
  }

  // --- Delegação ao modelo de carreira (CareerLevel) ---

  /// Tier atual a partir do nível de carreira (0–14) e pontos no tier (0–100).
  Tier getCurrentTierFromCareer(int levelIndex, int pointsInTier) {
    return Tier.fromCareerLevel(CareerLevel.at(levelIndex));
  }

  /// Progresso dentro do tier atual (0.0 a 1.0) para o modelo de carreira.
  double getTierProgressFromCareer(int levelIndex, int pointsInTier) {
    return (pointsInTier / CareerLevel.pointsPerTier).clamp(0.0, 1.0);
  }

  /// Pontos restantes para o próximo tier no modelo de carreira.
  int getPointsToNextTierFromCareer(int levelIndex, int pointsInTier) {
    if (pointsInTier >= CareerLevel.pointsPerTier) return 0;
    return CareerLevel.pointsPerTier - pointsInTier;
  }
}
