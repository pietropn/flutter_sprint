import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/turma.dart';
import '../models/professor.dart';
import '../models/trabalho.dart';
import '../models/evento_calendario.dart';
import '../utils/constants.dart';

/// Serviço de persistência local para os módulos de Turmas, Professores,
/// Trabalhos e Calendário.
///
/// Esses módulos existem nos protótipos da Sprint 2, porém a API REST do
/// projeto (desenvolvida por outra equipe) só expõe o recurso `/alunos`.
/// Para manter a fidelidade visual e de navegação com o protótipo, esses
/// dados são gerados uma única vez (seed) e depois lidos/gravados
/// diretamente no SharedPreferences, da mesma forma que o cache de alunos.
class AcademicLocalService {
  AcademicLocalService._internal();
  static final AcademicLocalService instance = AcademicLocalService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    if (!(_prefs!.getBool(AppConstants.keySeeded) ?? false)) {
      await _seed();
      await _prefs!.setBool(AppConstants.keySeeded, true);
    }
  }

  SharedPreferences get _p {
    if (_prefs == null) {
      throw StateError('AcademicLocalService não foi inicializado.');
    }
    return _prefs!;
  }

  // ---------------------------------------------------------------------
  // TURMAS
  // ---------------------------------------------------------------------
  List<Turma> getTurmas() {
    final raw = _p.getString(AppConstants.keyTurmas);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => Turma.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> saveTurmas(List<Turma> turmas) async {
    await _p.setString(AppConstants.keyTurmas, jsonEncode(turmas.map((t) => t.toMap()).toList()));
  }

  // ---------------------------------------------------------------------
  // PROFESSORES
  // ---------------------------------------------------------------------
  List<Professor> getProfessores() {
    final raw = _p.getString(AppConstants.keyProfessores);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => Professor.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> saveProfessores(List<Professor> professores) async {
    await _p.setString(
      AppConstants.keyProfessores,
      jsonEncode(professores.map((p) => p.toMap()).toList()),
    );
  }

  // ---------------------------------------------------------------------
  // TRABALHOS
  // ---------------------------------------------------------------------
  List<Trabalho> getTrabalhos() {
    final raw = _p.getString(AppConstants.keyTrabalhos);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => Trabalho.fromMap(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> saveTrabalhos(List<Trabalho> trabalhos) async {
    await _p.setString(
      AppConstants.keyTrabalhos,
      jsonEncode(trabalhos.map((t) => t.toMap()).toList()),
    );
  }

  // ---------------------------------------------------------------------
  // EVENTOS DO CALENDÁRIO
  // ---------------------------------------------------------------------
  List<EventoCalendario> getEventos() {
    final raw = _p.getString(AppConstants.keyEventos);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => EventoCalendario.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveEventos(List<EventoCalendario> eventos) async {
    await _p.setString(
      AppConstants.keyEventos,
      jsonEncode(eventos.map((e) => e.toMap()).toList()),
    );
  }

  // ---------------------------------------------------------------------
  // SEED INICIAL (executado apenas uma vez, na primeira abertura do app)
  // ---------------------------------------------------------------------
  Future<void> _seed() async {
    final turmas = [
      Turma(
        id: 't1',
        nome: 'Turma A',
        engajamentoPct: 81,
        faltasPct: 22,
        entregasPct: 62,
        professorResponsavel: 'Ana',
        alunos: const [
          TurmaAluno(
            nome: 'Silvio Toshiaki Yokoyama',
            media: 5.4,
            faltas: 8,
            ocorrencias: 1,
            notasBaixasPct: 30,
            trabalhosEntreguesPct: 10,
            status: 'Em risco',
          ),
          TurmaAluno(
            nome: 'Pietro de Paula Nascimento',
            media: 9.4,
            faltas: 0,
            ocorrencias: 0,
            notasBaixasPct: 0,
            trabalhosEntreguesPct: 100,
            status: 'Engajado',
          ),
          TurmaAluno(
            nome: 'Jhonatham Jesus de Souza Barros',
            media: 8.4,
            faltas: 1,
            ocorrencias: 0,
            notasBaixasPct: 5,
            trabalhosEntreguesPct: 95,
            status: 'Engajado',
          ),
          TurmaAluno(
            nome: 'Victor Andrade Baptista de Sousa',
            media: 8.7,
            faltas: 1,
            ocorrencias: 0,
            notasBaixasPct: 4,
            trabalhosEntreguesPct: 98,
            status: 'Engajado',
          ),
        ],
      ),
      const Turma(id: 't2', nome: 'Turma B', engajamentoPct: 74, faltasPct: 18, entregasPct: 70, professorResponsavel: 'Carlos', alunos: []),
      const Turma(id: 't3', nome: 'Turma C', engajamentoPct: 68, faltasPct: 30, entregasPct: 55, professorResponsavel: 'Beatriz', alunos: []),
      const Turma(id: 't4', nome: 'Turma D', engajamentoPct: 90, faltasPct: 8, entregasPct: 88, professorResponsavel: 'Diego', alunos: []),
      const Turma(id: 't5', nome: 'Turma E', engajamentoPct: 60, faltasPct: 35, entregasPct: 50, professorResponsavel: 'Elisa', alunos: []),
    ];

    final now = DateTime.now();
    final trabalhos = [
      Trabalho(
        id: 'tb1',
        titulo: 'Exercícios de Excel Avançado',
        descricao: 'Planilha com fórmulas de PROCV e tabelas dinâmicas.',
        unidade: 'Unidade Centro',
        curso: 'Curso de Excel',
        turma: 'Turma A',
        periodo: 'Manhã',
        anexoNome: 'exercicio_excel.pdf',
        dataPublicacao: now.subtract(const Duration(days: 3)),
        dataEntrega: now.add(const Duration(days: 4)),
        totalAlunos: 26,
        entreguesQtd: 10,
      ),
    ];

    final eventos = [
      EventoCalendario(
        id: 'ev1',
        titulo: 'Aula de Excel',
        data: DateTime(now.year, now.month, now.day),
        turma: 'Turma A',
        tipo: TipoEvento.aula,
      ),
      EventoCalendario(
        id: 'ev2',
        titulo: 'Entrega de Trabalho',
        data: DateTime(now.year, now.month, now.day + 5),
        turma: 'Turma A',
        tipo: TipoEvento.trabalho,
      ),
    ];

    await saveTurmas(turmas);
    await saveTrabalhos(trabalhos);
    await saveEventos(eventos);
    await saveProfessores(const []);
  }
}
