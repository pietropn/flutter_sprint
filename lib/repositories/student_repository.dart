import '../models/student.dart';
import '../services/api_service.dart';
import '../services/preferences_service.dart';

/// Repositório de Alunos integrado com o endpoint /alunos do Spring Boot
/// e cache offline persistido via SharedPreferences.
class StudentRepository {
  final ApiService _api = ApiService.instance;
  final PreferencesService _prefs = PreferencesService.instance;

  /// Retorna os alunos armazenados no cache local
  List<Student> getCachedStudents() {
    return _prefs.getCachedStudents();
  }

  /// Busca todos os alunos da API (GET /alunos) e atualiza o cache local
  Future<List<Student>> fetchAll() async {
    try {
      final resp = await _api.get('/alunos');
      if (resp is List) {
        final list = resp
            .map((e) => Student.fromApiJson(Map<String, dynamic>.from(e as Map)))
            .toList();

        // Salva a lista retornada no cache local (SharedPreferences)
        await _prefs.saveCachedStudents(list);
        return list;
      }
      throw ApiException('Formato inesperado retornado pela API');
    } catch (e) {
      // Se houver erro de rede, tenta recuperar do cache local
      final cached = _prefs.getCachedStudents();
      if (cached.isNotEmpty) {
        return cached;
      }
      rethrow;
    }
  }

  /// Cadastra um novo aluno na API (POST /alunos)
  Future<Student> create(Student s) async {
    final resp = await _api.post('/alunos', body: s.toApiJson());
    if (resp is Map) {
      final created = Student.fromApiJson(Map<String, dynamic>.from(resp));

      // Atualiza o cache local
      final cached = _prefs.getCachedStudents();
      cached.add(created);
      await _prefs.saveCachedStudents(cached);

      return created;
    }
    return s;
  }

  /// Remove um aluno da API (DELETE /alunos/{id})
  Future<void> delete(String id) async {
    await _api.delete('/alunos/$id');

    // Atualiza o cache local
    final cached = _prefs.getCachedStudents();
    cached.removeWhere((item) => item.id == id);
    await _prefs.saveCachedStudents(cached);
  }
}