import '../services/api_service.dart';
import '../models/user.dart';

class AuthRepository {
  final ApiService _api = ApiService.instance;

  /// POST /auth/login {email,password} -> { token, user }
  Future<Map<String, dynamic>> login(String email, String password) async {
    final resp = await _api.post('/auth/login', body: {'email': email, 'password': password});
    if (resp is Map) return Map<String, dynamic>.from(resp);
    throw Exception('Resposta inválida do servidor');
  }

  void setToken(String? token) => _api.setToken(token);
}