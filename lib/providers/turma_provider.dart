import 'package:flutter/material.dart';
import '../models/turma.dart';
import '../services/academic_local_service.dart';

/// Provider de Turmas. Os dados são mantidos localmente (SharedPreferences)
/// pois a API do projeto ainda não expõe um endpoint de turmas.
class TurmaProvider with ChangeNotifier {
  final AcademicLocalService _service = AcademicLocalService.instance;
  List<Turma> _turmas = [];

  TurmaProvider() {
    _turmas = _service.getTurmas();
  }

  List<Turma> get turmas => List.unmodifiable(_turmas);

  Turma? byId(String id) {
    try {
      return _turmas.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Retorna a turma sob responsabilidade do professor logado (comparação
  /// case-insensitive pelo nome). Se nenhuma turma corresponder (ex.: conta
  /// de demonstração), cai para a primeira turma cadastrada.
  Turma? byProfessor(String? nomeProfessor) {
    if (_turmas.isEmpty) return null;
    if (nomeProfessor == null || nomeProfessor.trim().isEmpty) return _turmas.first;
    final alvo = nomeProfessor.trim().toLowerCase();
    try {
      return _turmas.firstWhere(
        (t) => t.professorResponsavel.trim().toLowerCase() == alvo,
      );
    } catch (_) {
      return _turmas.first;
    }
  }

  Future<void> marcarOcorrencia(String turmaId, String alunoNome) async {
    final idx = _turmas.indexWhere((t) => t.id == turmaId);
    if (idx == -1) return;
    final turma = _turmas[idx];
    final alunos = turma.alunos.map((a) {
      if (a.nome != alunoNome) return a;
      return TurmaAluno(
        nome: a.nome,
        media: a.media,
        faltas: a.faltas,
        ocorrencias: a.ocorrencias + 1,
        notasBaixasPct: a.notasBaixasPct,
        trabalhosEntreguesPct: a.trabalhosEntreguesPct,
        status: a.status,
      );
    }).toList();

    _turmas[idx] = Turma(
      id: turma.id,
      nome: turma.nome,
      engajamentoPct: turma.engajamentoPct,
      faltasPct: turma.faltasPct,
      entregasPct: turma.entregasPct,
      professorResponsavel: turma.professorResponsavel,
      alunos: alunos,
    );

    await _service.saveTurmas(_turmas);
    notifyListeners();
  }
}
