import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/career_level.dart';
import '../services/career_progress_service.dart';

const String _keyLevelIndex = 'user_career_level_index';
const String _keyPointsInTier = 'user_career_points_in_tier';

/// Estado global da carreira do usuário (levelIndex, pointsInTier).
/// Persiste em SharedPreferences.
class UserCareerProvider extends ChangeNotifier {
  UserCareerProvider({
    CareerProgressService? careerProgressService,
    int? initialLevelIndex,
    int? initialPointsInTier,
  })  : _service = careerProgressService ?? CareerProgressService(),
        _levelIndex = initialLevelIndex ?? 0,
        _pointsInTier = (initialPointsInTier ?? 0).clamp(0, CareerLevel.pointsPerTier);

  final CareerProgressService _service;

  int _levelIndex;
  int _pointsInTier;
  int? _rankInTier;

  int get levelIndex => _levelIndex;
  int get pointsInTier => _pointsInTier;
  int? get rankInTier => _rankInTier;

  CareerLevel get currentLevel => _service.getCurrentLevel(_levelIndex);
  double get progressToNextTier => _service.getProgressToNextTier(_pointsInTier);
  int get pointsToNextTier => _service.getPointsToNextTier(_pointsInTier);
  bool get isMaxLevel => currentLevel.isMaxLevel;

  /// Adiciona pontos. Retorna true se subiu de tier.
  Future<bool> addPoints(int delta) async {
    final result = _service.addPoints(_levelIndex, _pointsInTier, delta);
    _levelIndex = result.newLevelIndex;
    _pointsInTier = result.newPointsInTier;
    await _persist();
    notifyListeners();
    return result.leveledUp;
  }

  /// Carrega estado do disco (chamar no startup).
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _levelIndex = prefs.getInt(_keyLevelIndex) ?? 0;
    _pointsInTier = (prefs.getInt(_keyPointsInTier) ?? 0).clamp(0, CareerLevel.pointsPerTier);
    _levelIndex = _levelIndex.clamp(0, CareerLevel.totalLevels - 1);
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLevelIndex, _levelIndex);
    await prefs.setInt(_keyPointsInTier, _pointsInTier);
  }

  /// Define a posição do usuário no ranking do tier atual (ex.: ao carregar ranking).
  void setRankInTier(int? rank) {
    if (_rankInTier == rank) return;
    _rankInTier = rank;
    notifyListeners();
  }

  /// Para testes: define nível e pontos manualmente
  Future<void> setLevel(int levelIndex, int pointsInTier) async {
    _levelIndex = levelIndex.clamp(0, CareerLevel.totalLevels - 1);
    _pointsInTier = pointsInTier.clamp(0, CareerLevel.pointsPerTier);
    await _persist();
    notifyListeners();
  }

  int getTimeLimitForLevel() => _service.getTimeLimitForLevel(_levelIndex);
  int getHintCountForLevel() => _service.getHintCountForLevel(_levelIndex);
  double getPenaltyMultiplierForLevel() => _service.getPenaltyMultiplierForLevel(_levelIndex);
}
