import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _keyHighContrast = 'high_contrast';
  static const String _keyPushNotifications = 'push_notifications';
  static const String _keyEpidemiologicalAlerts = 'epidemiological_alerts';
  static const String _keyTextScale = 'text_scale';
  static const String _keyEcoMode = 'eco_mode';

  bool _highContrast = false;
  bool _pushNotifications = true;
  bool _epidemiologicalAlerts = true;
  bool _ecoModeEnabled = false;
  double _textScale = 1.0;
  static const double _minTextScale = 0.9;
  static const double _maxTextScale = 1.4;

  bool get highContrast => _highContrast;
  bool get pushNotifications => _pushNotifications;
  bool get epidemiologicalAlerts => _epidemiologicalAlerts;
  bool get ecoModeEnabled => _ecoModeEnabled;
  double get textScale => _textScale;
  double get minTextScale => _minTextScale;
  double get maxTextScale => _maxTextScale;

  SettingsService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _highContrast = prefs.getBool(_keyHighContrast) ?? false;
      _pushNotifications = prefs.getBool(_keyPushNotifications) ?? true;
      _epidemiologicalAlerts = prefs.getBool(_keyEpidemiologicalAlerts) ?? true;
      _ecoModeEnabled = prefs.getBool(_keyEcoMode) ?? false;
      _textScale = (prefs.getDouble(_keyTextScale) ?? 1.0)
          .clamp(_minTextScale, _maxTextScale);
      notifyListeners();
    } catch (e) {
      // Se houver erro ao carregar, usar valores padrão
      _highContrast = false;
      _pushNotifications = true;
      _epidemiologicalAlerts = true;
      _ecoModeEnabled = false;
      _textScale = 1.0;
    }
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyHighContrast, value);
      notifyListeners();
    } catch (e) {
      // Se houver erro ao salvar, apenas atualizar o estado
      notifyListeners();
    }
  }

  Future<void> setPushNotifications(bool value) async {
    _pushNotifications = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyPushNotifications, value);
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> setEpidemiologicalAlerts(bool value) async {
    _epidemiologicalAlerts = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyEpidemiologicalAlerts, value);
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> setTextScale(double value) async {
    _textScale = value.clamp(_minTextScale, _maxTextScale);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_keyTextScale, _textScale);
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  Future<void> setEcoModeEnabled(bool value) async {
    _ecoModeEnabled = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyEcoMode, value);
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }
}
