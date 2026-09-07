import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';
import '../repositories/student_repository.dart';

/// Provider de gerenciamento do estado dos Alunos com suporte a cache local.
class StudentProvider with ChangeNotifier {
  final StudentRepository _repo = StudentRepository();
  final List<Student> _items = [];
  bool _loading = false;
  String? _error;
  bool _isOfflineData = false;

  StudentProvider() {
    _loadFromCache();
  }

  bool get loading => _loading;
  String? get error => _error;
  bool get isOfflineData => _isOfflineData;
  List<Student> get students => List.unmodifiable(_items);

  /// Carrega imediatamente os dados do cache local do SharedPreferences
  void _loadFromCache() {
    final cached = _repo.getCachedStudents();
    if (cached.isNotEmpty) {
      _items
        ..clear()
        ..addAll(cached);
      _isOfflineData = true;
      notifyListeners();
    }
  }

  /// Busca os alunos mais recentes da API e sincroniza com o cache local
  Future<void> loadAll() async {
    _setLoading(true);
    _error = null;
    try {
      final list = await _repo.fetchAll();
      _items
        ..clear()
        ..addAll(list);
      _isOfflineData = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      // Se tiver dados em cache, permanece exibindo em modo offline
      if (_items.isNotEmpty) {
        _isOfflineData = true;
      }
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Adiciona um novo aluno com nome, CPF, email e turma.
  /// Retorna `true` se foi realmente enviado para a API, ou `false` se
  /// ficou salvo apenas localmente (API indisponível no momento).
  Future<bool> add({
    required String name,
    required String cpf,
    required String email,
    required String turma,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final s = Student(
        id: const Uuid().v4(),
        name: name,
        cpf: cpf,
        email: email,
        turma: turma,
      );
      final result = await _repo.create(s);
      _items.add(result.student);
      if (!result.synced) {
        _isOfflineData = true;
      }
      notifyListeners();
      return result.synced;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Remove um aluno pelo ID. Retorna `true` se a remoção foi
  /// sincronizada com a API, ou `false` se só foi removida localmente.
  Future<bool> remove(String id) async {
    _setLoading(true);
    _error = null;
    try {
      final synced = await _repo.delete(id);
      _items.removeWhere((it) => it.id == id);
      if (!synced) {
        _isOfflineData = true;
      }
      notifyListeners();
      return synced;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}