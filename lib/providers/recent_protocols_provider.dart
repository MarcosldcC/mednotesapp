import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mantém a lista de protocolos/algoritmos salvos para exibir no dashboard.
/// Persiste em SharedPreferences (sem backend).
class RecentProtocolsProvider extends ChangeNotifier {
  static const String _keyRecentProtocols = 'recent_protocols';
  static const int _maxRecent = 10;

  List<String> _titles = [];

  List<String> get titles => List.unmodifiable(_titles);

  RecentProtocolsProvider() {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_keyRecentProtocols);
      if (json != null) {
        final list = jsonDecode(json) as List<dynamic>?;
        _titles = list?.map((e) => e.toString()).toList() ?? [];
        notifyListeners();
      }
    } catch (_) {
      _titles = [];
    }
  }

  Future<void> add(String title) async {
    if (title.isEmpty) return;
    _titles.remove(title);
    _titles.insert(0, title);
    if (_titles.length > _maxRecent) {
      _titles = _titles.take(_maxRecent).toList();
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyRecentProtocols, jsonEncode(_titles));
    } catch (_) {}
    notifyListeners();
  }

  Future<void> clear() async {
    _titles = [];
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyRecentProtocols);
    } catch (_) {}
    notifyListeners();
  }
}
