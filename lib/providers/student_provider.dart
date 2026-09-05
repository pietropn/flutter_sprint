import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';
import '../repositories/student_repository.dart';

class StudentProvider with ChangeNotifier {
  final StudentRepository _repo = StudentRepository();
  final List<Student> _items = [];
  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;
  List<Student> get students => List.unmodifiable(_items);

  Future<void> loadAll() async {
    _setLoading(true);
    _error = null;
    try {
      final list = await _repo.fetchAll();
      _items
        ..clear()
        ..addAll(list);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> add({required String name, required String email, required String turma}) async {
    _setLoading(true);
    _error = null;
    try {
      final s = Student(id: Uuid().v4(), name: name, email: email, turma: turma);
      final created = await _repo.create(s);
      _items.add(created);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> remove(String id) async {
    _setLoading(true);
    _error = null;
    try {
      await _repo.delete(id);
      _items.removeWhere((it) => it.id == id);
      notifyListeners();
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