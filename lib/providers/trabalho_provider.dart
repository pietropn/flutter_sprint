import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/trabalho.dart';
import '../services/academic_local_service.dart';

/// Provider de Trabalhos publicados pelo professor (persistência local).
class TrabalhoProvider with ChangeNotifier {
  final AcademicLocalService _service = AcademicLocalService.instance;
  List<Trabalho> _trabalhos = [];
  bool _loading = false;

  TrabalhoProvider() {
    _trabalhos = _service.getTrabalhos();
  }

  bool get loading => _loading;
  List<Trabalho> get trabalhos => List.unmodifiable(_trabalhos.reversed);

  Future<void> publicar({
    required String titulo,
    required String descricao,
    required String unidade,
    required String curso,
    required String turma,
    required String periodo,
    required String anexoNome,
  }) async {
    _loading = true;
    notifyListeners();

    final novo = Trabalho(
      id: const Uuid().v4(),
      titulo: titulo,
      descricao: descricao,
      unidade: unidade,
      curso: curso,
      turma: turma,
      periodo: periodo,
      anexoNome: anexoNome,
      dataPublicacao: DateTime.now(),
      dataEntrega: DateTime.now().add(const Duration(days: 7)),
      totalAlunos: 26,
      entreguesQtd: 0,
    );

    _trabalhos.add(novo);
    await _service.saveTrabalhos(_trabalhos);

    _loading = false;
    notifyListeners();
  }
}
