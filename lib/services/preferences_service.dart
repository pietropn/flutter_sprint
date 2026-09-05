import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/student.dart';
import '../utils/constants.dart';

/// Serviço central de Persistência Local com SharedPreferences.
///
/// Atende aos requisitos da avaliação:
/// 1. Manter usuário logado (token + user profile)
/// 2. Salvar configurações (URL base da API personalizada)
/// 3. Armazenar preferências (Tema escuro/claro e Lembrar e-mail)
/// 4. Cache simples de dados (Cache offline de estudantes)
class PreferencesService {
  PreferencesService._internal();
  static final PreferencesService instance = PreferencesService._internal();

  SharedPreferences? _prefs;

  /// Inicializa o SharedPreferences na inicialização do app
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw StateError(
        'PreferencesService não foi inicializado. Chame PreferencesService.instance.init() no main().',
      );
    }
    return _prefs!;
  }

  // ==========================================
  // 1. MANTER USUÁRIO LOGADO (Sessão & Token)
  // ==========================================

  Future<void> saveUserSession({required User user, required String token}) async {
    await _preferences.setString(AppConstants.keyToken, token);
    await _preferences.setString(AppConstants.keyUser, jsonEncode(user.toJson()));
  }

  User? getUser() {
    final userJson = _preferences.getString(AppConstants.keyUser);
    if (userJson == null) return null;
    try {
      final decoded = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  String? getToken() {
    return _preferences.getString(AppConstants.keyToken);
  }

  bool isLoggedIn() {
    final token = getToken();
    final user = getUser();
    return token != null && token.isNotEmpty && user != null;
  }

  Future<void> clearUserSession() async {
    await _preferences.remove(AppConstants.keyToken);
    await _preferences.remove(AppConstants.keyUser);
  }

  // ==========================================
  // 2. SALVAR CONFIGURAÇÕES (URL Base da API)
  // ==========================================

  String getApiUrl() {
    return _preferences.getString(AppConstants.keyApiUrl) ?? AppConstants.defaultApiUrl;
  }

  Future<void> setApiUrl(String url) async {
    final cleanUrl = url.trim().replaceAll(RegExp(r'/+$'), '');
    await _preferences.setString(AppConstants.keyApiUrl, cleanUrl);
  }

  // ==========================================
  // 3. ARMAZENAR PREFERÊNCIAS (Tema & Login)
  // ==========================================

  bool isDarkMode() {
    return _preferences.getBool(AppConstants.keyDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    await _preferences.setBool(AppConstants.keyDarkMode, isDark);
  }

  bool getRememberEmail() {
    return _preferences.getBool(AppConstants.keyRememberEmail) ?? false;
  }

  Future<void> setRememberEmail(bool value) async {
    await _preferences.setBool(AppConstants.keyRememberEmail, value);
    if (!value) {
      await _preferences.remove(AppConstants.keySavedEmail);
    }
  }

  String? getSavedEmail() {
    return _preferences.getString(AppConstants.keySavedEmail);
  }

  Future<void> setSavedEmail(String email) async {
    await _preferences.setString(AppConstants.keySavedEmail, email);
  }

  // ==========================================
  // 4. CACHE SIMPLES DE DADOS (Alunos)
  // ==========================================

  List<Student> getCachedStudents() {
    final jsonStr = _preferences.getString(AppConstants.keyCachedStudents);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded
            .map((item) => Student.fromMap(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> saveCachedStudents(List<Student> students) async {
    final listMap = students.map((s) => s.toMap()).toList();
    await _preferences.setString(AppConstants.keyCachedStudents, jsonEncode(listMap));
  }

  Future<void> clearCachedStudents() async {
    await _preferences.remove(AppConstants.keyCachedStudents);
  }
}
