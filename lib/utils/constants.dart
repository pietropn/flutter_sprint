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
  static const String keyFichasAlunos = 'sp_fichas_alunos';

  // Módulos acadêmicos locais (Turmas, Professores, Trabalhos, Calendário).
  // A API do projeto ainda não expõe esses recursos; por isso são
  // simulados e persistidos localmente no SharedPreferences, seguindo
  // fielmente as telas do protótipo da Sprint 2.
  static const String keyTurmas = 'sp_turmas';
  static const String keyProfessores = 'sp_professores';
  static const String keyTrabalhos = 'sp_trabalhos';
  static const String keyEventos = 'sp_eventos';
  static const String keySeeded = 'sp_academic_seeded_v1';

  // URL padrão da API (Sprint_microservico Spring Boot)
  static const String defaultApiUrl = 'http://localhost:8080';
}

// Mantido para compatibilidade retroativa
const String kApiUrl = AppConstants.defaultApiUrl;
