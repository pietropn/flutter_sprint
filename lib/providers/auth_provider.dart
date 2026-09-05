import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../services/preferences_service.dart';

/// Provider de Autenticação com persistência de sessão no SharedPreferences.
/// Atende ao requisito de "Manter usuário logado".
class AuthProvider with ChangeNotifier {
  final AuthRepository _repo = AuthRepository();
  final PreferencesService _prefs = PreferencesService.instance;

  User? _user;
  String? _token;
  bool _loading = false;
  String? _error;
  bool _rememberEmail = false;
  String? _savedEmail;

  AuthProvider() {
    _restoreSession();
  }

  bool get loading => _loading;
  String? get error => _error;
  User? get user => _user;
  String? get token => _token;
  bool get isLogged => _user != null && _token != null;
  bool get rememberEmail => _rememberEmail;
  String? get savedEmail => _savedEmail;

  /// Restaura a sessão salva no SharedPreferences ao iniciar o aplicativo
  void _restoreSession() {
    _rememberEmail = _prefs.getRememberEmail();
    _savedEmail = _prefs.getSavedEmail();

    if (_prefs.isLoggedIn()) {
      _user = _prefs.getUser();
      _token = _prefs.getToken();
      _repo.setToken(_token);
    }
  }

  Future<void> login(String email, String password, {bool remember = false}) async {
    _setLoading(true);
    _error = null;
    try {
      final resp = await _repo.login(email, password);
      final token = resp['token'] as String?;
      final userJson = resp['user'] as Map<String, dynamic>?;

      if (token == null || userJson == null) {
        throw Exception('Resposta da API sem token ou usuário');
      }

      _token = token;
      _user = User.fromJson(userJson);

      // Persiste a sessão no SharedPreferences (Manter usuário logado)
      await _repo.saveSession(_user!, _token!);

      // Persiste a preferência de lembrar e-mail
      _rememberEmail = remember;
      await _prefs.setRememberEmail(remember);
      if (remember) {
        _savedEmail = email;
        await _prefs.setSavedEmail(email);
      } else {
        _savedEmail = null;
        await _prefs.setSavedEmail('');
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _repo.clearSession();
    notifyListeners();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}