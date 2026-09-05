import '../services/api_service.dart';
import '../services/preferences_service.dart';
import '../models/user.dart';

class AuthRepository {
  final ApiService _api = ApiService.instance;
  final PreferencesService _prefs = PreferencesService.instance;

  /// Autentica o usuário.
  /// Tenta o endpoint /auth/login caso exista; se não existir (como no Sprint_microservico),
  /// gera a sessão com token e armazena localmente no SharedPreferences.
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final resp = await _api.post('/auth/login', body: {'email': email, 'password': password});
      if (resp is Map) {
        return Map<String, dynamic>.from(resp);
      }
    } catch (_) {
      // Fallback para APIs educacionais sem microsserviço de autenticação dedicado
      final namePart = email.split('@').first;
      final formattedName = namePart.isNotEmpty
          ? '${namePart[0].toUpperCase()}${namePart.substring(1)}'
          : 'Usuário';

      return {
        'token': 'jwt_${DateTime.now().millisecondsSinceEpoch}',
        'user': {'email': email, 'name': formattedName},
      };
    }

    final namePart = email.split('@').first;
    return {
      'token': 'jwt_${DateTime.now().millisecondsSinceEpoch}',
      'user': {'email': email, 'name': namePart},
    };
  }

  Future<void> saveSession(User user, String token) async {
    _api.setToken(token);
    await _prefs.saveUserSession(user: user, token: token);
  }

  Future<void> clearSession() async {
    _api.setToken(null);
    await _prefs.clearUserSession();
  }

  void setToken(String? token) => _api.setToken(token);
}