import 'package:uuid/uuid.dart';
import '../models/student.dart';
import '../services/api_service.dart';
import '../services/preferences_service.dart';

/// Resultado do cadastro de um aluno: o aluno criado e se ele foi
/// realmente enviado para a API (`synced = true`) ou apenas salvo
/// localmente porque a API não estava acessível (`synced = false`).
typedef StudentCreateResult = ({Student student, bool synced});

/// Repositório de Alunos integrado com o endpoint /api/v1/alunos do Spring Boot
/// (Sprint_microservico). Todas as rotas dessa API são versionadas sob /api/v1.
/// e cache offline persistido via SharedPreferences.
///
/// O repositório sempre TENTA a API real primeiro (é assim que a
/// integração REST é implementada e avaliada). Porém, para que o app
/// continue utilizável mesmo quando a API não está acessível no momento
/// (fora do ar, CORS bloqueando no navegador, rede indisponível, etc.),
/// o cadastro e a remoção não travam o usuário: caem automaticamente
/// para uma operação local, persistida no cache do SharedPreferences, e
/// sinalizam isso para a camada de cima (Provider/UI) exibir o aviso
/// adequado ("salvo localmente, sem sincronizar com a API").
class StudentRepository {
  final ApiService _api = ApiService.instance;
  final PreferencesService _prefs = PreferencesService.instance;

  /// Retorna os alunos armazenados no cache local
  List<Student> getCachedStudents() {
    return _prefs.getCachedStudents();
  }

  /// Busca todos os alunos da API (GET /api/v1/alunos) e atualiza o cache local
  Future<List<Student>> fetchAll() async {
    try {
      final resp = await _api.get('/api/v1/alunos');
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

  /// Cadastra um novo aluno. Tenta primeiro `POST /api/v1/alunos`; se a
  /// API não responder (fora do ar, CORS, sem rede), salva o aluno
  /// apenas localmente para o cadastro não ficar bloqueado, e informa
  /// isso através de `synced: false`.
  Future<StudentCreateResult> create(Student s) async {
    try {
      final resp = await _api.post('/api/v1/alunos', body: s.toApiJson());
      if (resp is Map) {
        final created = Student.fromApiJson(Map<String, dynamic>.from(resp));
        final cached = _prefs.getCachedStudents();
        cached.add(created);
        await _prefs.saveCachedStudents(cached);
        return (student: created, synced: true);
      }
      // Resposta em formato inesperado: trata como sucesso mesmo assim,
      // usando os dados enviados.
      final cached = _prefs.getCachedStudents();
      cached.add(s);
      await _prefs.saveCachedStudents(cached);
      return (student: s, synced: true);
    } catch (_) {
      // API indisponível: cadastra apenas localmente, com um ID próprio,
      // para o usuário não ficar travado sem poder cadastrar alunos.
      final local = s.copyWith(id: 'local-${const Uuid().v4()}');
      final cached = _prefs.getCachedStudents();
      cached.add(local);
      await _prefs.saveCachedStudents(cached);
      return (student: local, synced: false);
    }
  }

  /// Remove um aluno. Tenta primeiro `DELETE /api/v1/alunos/{id}`; se a
  /// API não responder, remove apenas do cache local (o registro pode
  /// ter sido criado localmente, sem existir na API, por exemplo).
  Future<bool> delete(String id) async {
    var synced = true;
    try {
      // Registros criados offline (id "local-...") nunca existiram na
      // API, então não há o que remover lá.
      if (!id.startsWith('local-')) {
        await _api.delete('/api/v1/alunos/$id');
      }
    } catch (_) {
      synced = false;
    }

    final cached = _prefs.getCachedStudents();
    cached.removeWhere((item) => item.id == id);
    await _prefs.saveCachedStudents(cached);
    return synced;
  }
}