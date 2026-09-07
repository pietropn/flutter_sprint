/// Representa o desempenho de um aluno dentro de uma turma, conforme a
/// tela "Turma" do protótipo (média, faltas, ocorrências, status).
class TurmaAluno {
  final String nome;
  final double media;
  final int faltas;
  final int ocorrencias;
  final int notasBaixasPct;
  final int trabalhosEntreguesPct;
  final String status; // 'Engajado' | 'Em risco'

  const TurmaAluno({
    required this.nome,
    required this.media,
    required this.faltas,
    required this.ocorrencias,
    required this.notasBaixasPct,
    required this.trabalhosEntreguesPct,
    required this.status,
  });

  factory TurmaAluno.fromMap(Map<String, dynamic> m) => TurmaAluno(
        nome: m['nome'] ?? '',
        media: (m['media'] as num?)?.toDouble() ?? 0,
        faltas: (m['faltas'] as num?)?.toInt() ?? 0,
        ocorrencias: (m['ocorrencias'] as num?)?.toInt() ?? 0,
        notasBaixasPct: (m['notasBaixasPct'] as num?)?.toInt() ?? 0,
        trabalhosEntreguesPct: (m['trabalhosEntreguesPct'] as num?)?.toInt() ?? 0,
        status: m['status'] ?? 'Engajado',
      );

  Map<String, dynamic> toMap() => {
        'nome': nome,
        'media': media,
        'faltas': faltas,
        'ocorrencias': ocorrencias,
        'notasBaixasPct': notasBaixasPct,
        'trabalhosEntreguesPct': trabalhosEntreguesPct,
        'status': status,
      };
}

/// Representa uma turma com seus indicadores de engajamento, conforme as
/// telas "Turma", "Home Gestor" (grade de turmas) e "Dashboard".
class Turma {
  final String id;
  final String nome;
  final int engajamentoPct;
  final int faltasPct;
  final int entregasPct;
  final String professorResponsavel;
  final List<TurmaAluno> alunos;

  const Turma({
    required this.id,
    required this.nome,
    required this.engajamentoPct,
    required this.faltasPct,
    required this.entregasPct,
    this.professorResponsavel = '',
    required this.alunos,
  });

  factory Turma.fromMap(Map<String, dynamic> m) => Turma(
        id: m['id']?.toString() ?? '',
        nome: m['nome'] ?? '',
        engajamentoPct: (m['engajamentoPct'] as num?)?.toInt() ?? 0,
        faltasPct: (m['faltasPct'] as num?)?.toInt() ?? 0,
        entregasPct: (m['entregasPct'] as num?)?.toInt() ?? 0,
        professorResponsavel: m['professorResponsavel'] ?? '',
        alunos: (m['alunos'] as List<dynamic>? ?? [])
            .map((a) => TurmaAluno.fromMap(Map<String, dynamic>.from(a as Map)))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'engajamentoPct': engajamentoPct,
        'faltasPct': faltasPct,
        'entregasPct': entregasPct,
        'professorResponsavel': professorResponsavel,
        'alunos': alunos.map((a) => a.toMap()).toList(),
      };
}
