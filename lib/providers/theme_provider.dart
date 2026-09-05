import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

/// Provider responsável por gerenciar e persistir o tema do app (Claro / Escuro).
/// Atende ao requisito de Armazenar Preferências locais.
class ThemeProvider with ChangeNotifier {
  final PreferencesService _prefs = PreferencesService.instance;
  late bool _isDarkMode;

  ThemeProvider() {
    _isDarkMode = _prefs.isDarkMode();
  }

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    await _prefs.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
