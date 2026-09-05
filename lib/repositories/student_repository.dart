import '../models/student.dart';
import '../services/api_service.dart';

class StudentRepository {
  final ApiService _api = ApiService.instance;

  Future<List<Student>> fetchAll() async {
    final resp = await _api.get('/students');
    if (resp is List) return resp.map((e) => Student.fromMap(Map<String, dynamic>.from(e))).toList();
    throw Exception('Formato inesperado ao buscar alunos');
  }

  Future<Student> create(Student s) async {
    final resp = await _api.post('/students', body: s.toMap());
    if (resp is Map) return Student.fromMap(Map<String, dynamic>.from(resp));
    return s; // fallback
  }

  Future<void> delete(String id) async {
    await _api.delete('/students/$id');
  }
}