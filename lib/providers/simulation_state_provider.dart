import 'dart:async';

import 'package:flutter/foundation.dart';

/// Estado da simulação clínica: casos ocultos, vidas e cronômetro.
/// Persiste entre telas do fluxo de simulação.
class SimulationStateProvider extends ChangeNotifier {
  final Set<String> _hiddenCaseIds = {};
  int _lives = 3;

  bool _simulationInProgress = false;
  DateTime? _startTime;
  int _elapsedSeconds = 0;
  Timer? _chronoTimer;

  static const int initialLives = 3;

  int get lives => _lives;
  bool get simulationInProgress => _simulationInProgress;
  int get elapsedSeconds => _elapsedSeconds;

  bool isCaseHidden(String caseId) => _hiddenCaseIds.contains(caseId);

  void toggleCaseVisibility(String caseId) {
    if (_hiddenCaseIds.contains(caseId)) {
      _hiddenCaseIds.remove(caseId);
    } else {
      _hiddenCaseIds.add(caseId);
    }
    notifyListeners();
  }

  void resetLives() {
    _lives = initialLives;
    notifyListeners();
  }

  void decrementLife() {
    if (_lives > 0) {
      _lives--;
      notifyListeners();
    }
  }

  /// Inicia o cronômetro ao começar a simulação de caso.
  void startSimulation() {
    if (_simulationInProgress) return;
    _simulationInProgress = true;
    _startTime = DateTime.now();
    _elapsedSeconds = 0;
    _chronoTimer?.cancel();
    _chronoTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_startTime != null) {
        _elapsedSeconds = DateTime.now().difference(_startTime!).inSeconds;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  /// Ao sair (abandonar): para o cronômetro, perde progresso e as 3 vidas.
  void endSimulation() {
    _chronoTimer?.cancel();
    _chronoTimer = null;
    _simulationInProgress = false;
    _startTime = null;
    _elapsedSeconds = 0;
    _lives = initialLives;
    notifyListeners();
  }

  /// Ao concluir o caso com sucesso: para o cronômetro, mantém tempo final.
  void completeSimulation() {
    _chronoTimer?.cancel();
    _chronoTimer = null;
    _simulationInProgress = false;
    notifyListeners();
  }
}
