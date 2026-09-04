import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  static const _userKey = 'logged_user';
  User? _user;

  bool get isLoggedIn => _user != null;
  User? get user => _user;

  AuthService() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_userKey);
    if (json != null) {
      _user = User.fromJson(Map<String, dynamic>.from(jsonDecode(json)));
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    // validação básica no service (simulação).
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email e senha são obrigatórios.');
    }
    // Simula chamada de API
    await Future.delayed(Duration(seconds: 1));
    // Aqui você faria autenticação real. Vamos aceitar qualquer combinação válida:
    _user = User(email: email, name: 'Usuário Exemplo');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userKey, jsonEncode(_user!.toJson()));
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    notifyListeners();
  }
}