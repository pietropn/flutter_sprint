import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/student.dart';
import 'package:uuid/uuid.dart';

class StorageService with ChangeNotifier {
  static late StorageService instance;
  static const _boxName = 'appBox';
  Box<dynamic>? _box;

  StorageService._internal();

  static Future<void> init() async {
    instance = StorageService._internal();
    await instance._open();
  }

  Future<void> _open() async {
    _box = await Hive.openBox(_boxName);
  }

  List<Student> getStudents() {
    final list = _box?.get('students', defaultValue: []) as List;
    return list.map((e) => Student.fromMap(Map<dynamic, dynamic>.from(e))).toList();
  }

  Future<void> addStudent(Student s) async {
    final list = List<Map>.from(_box?.get('students', defaultValue: []) as List);
    list.add(s.toMap());
    await _box?.put('students', list);
    notifyListeners();
  }

  Future<void> removeStudent(String id) async {
    final list = List<Map>.from(_box?.get('students', defaultValue: []) as List);
    list.removeWhere((m) => m['id'] == id);
    await _box?.put('students', list);
    notifyListeners();
  }
}