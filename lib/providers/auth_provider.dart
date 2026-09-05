import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _repo = AuthRepository();
  User? _user;
  String? _token;
  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;
  User? get user => _user;
  bool get isLogged => _user != null;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _error = null;
    try {
      final resp = await _repo.login(email, password);
      final token = resp['token'] as String?;
      final userJson = resp['user'] as Map<String, dynamic>?;
      if (token == null || userJson == null) throw Exception('Resposta da API sem token/usuário');
      _token = token;
      _repo.setToken(_token);
      _user = User.fromJson(userJson);
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
    _repo.setToken(null);
    notifyListeners();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}