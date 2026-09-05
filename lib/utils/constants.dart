/// Chaves de persistência local (SharedPreferences) e valores padrão
class AppConstants {
  // Chaves do SharedPreferences
  static const String keyToken = 'sp_token';
  static const String keyUser = 'sp_user';
  static const String keyApiUrl = 'sp_api_url';
  static const String keyDarkMode = 'sp_dark_mode';
  static const String keyRememberEmail = 'sp_remember_email';
  static const String keySavedEmail = 'sp_saved_email';
  static const String keyCachedStudents = 'sp_cached_students';

  // URL padrão da API (Sprint_microservico Spring Boot)
  static const String defaultApiUrl = 'http://localhost:8080';
}

// Mantido para compatibilidade retroativa
const String kApiUrl = AppConstants.defaultApiUrl;
