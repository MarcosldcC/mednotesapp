import '../models/career_level.dart';

/// Resultado ao adicionar pontos (indica se houve subida de tier)
class AddPointsResult {
  final bool leveledUp;
  final int newLevelIndex;
  final int newPointsInTier;

  const AddPointsResult({
    required this.leveledUp,
    required this.newLevelIndex,
    required this.newPointsInTier,
  });
}

/// Serviço de progressão da carreira médica (15 níveis, 100 pts por tier).
class CareerProgressService {
  /// Pontos necessários por tier
  static const int pointsPerTier = CareerLevel.pointsPerTier;

  /// Retorna o nível atual para um levelIndex
  CareerLevel getCurrentLevel(int levelIndex) {
    return CareerLevel.at(levelIndex);
  }

  /// Progresso dentro do tier atual (0.0 a 1.0)
  double getProgressToNextTier(int pointsInTier) {
    return (pointsInTier / pointsPerTier).clamp(0.0, 1.0);
  }

  /// Pontos restantes para o próximo tier
  int getPointsToNextTier(int pointsInTier) {
    if (pointsInTier >= pointsPerTier) return 0;
    return pointsPerTier - pointsInTier;
  }

  /// Adiciona pontos. Se atingir 100, avança tier e zera pontos.
  /// Retorna o resultado (leveledUp, newLevelIndex, newPointsInTier).
  AddPointsResult addPoints(int levelIndex, int pointsInTier, int delta) {
    final newPoints = pointsInTier + delta;
    if (levelIndex >= CareerLevel.totalLevels - 1) {
      return AddPointsResult(
        leveledUp: false,
        newLevelIndex: levelIndex,
        newPointsInTier: pointsInTier.clamp(0, pointsPerTier),
      );
    }
    if (newPoints >= pointsPerTier) {
      return AddPointsResult(
        leveledUp: true,
        newLevelIndex: levelIndex + 1,
        newPointsInTier: 0,
      );
    }
    return AddPointsResult(
      leveledUp: false,
      newLevelIndex: levelIndex,
      newPointsInTier: newPoints.clamp(0, pointsPerTier - 1),
    );
  }

  /// Retorna tempo limite base para simulações (em segundos) por nível.
  /// Quanto maior o nível, menos tempo.
  int getTimeLimitForLevel(int levelIndex) {
    const base = 180;
    final reduction = (levelIndex * 6).clamp(0, 90);
    return (base - reduction).clamp(90, 180);
  }

  /// Número de dicas disponíveis por nível (menos em níveis altos).
  int getHintCountForLevel(int levelIndex) {
    if (levelIndex < 3) return 3;
    if (levelIndex < 6) return 2;
    if (levelIndex < 9) return 1;
    return 0;
  }

  /// Multiplicador de penalidade por nível (maior em níveis altos).
  double getPenaltyMultiplierForLevel(int levelIndex) {
    return 1.0 + (levelIndex * 0.1);
  }
}
