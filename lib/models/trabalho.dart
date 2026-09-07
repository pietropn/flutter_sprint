/// Representa um trabalho/atividade publicado pelo professor, conforme a
/// tela "Trabalhos Ho..." do protótipo. Persistido localmente.
class Trabalho {
  final String id;
  final String titulo;
  final String descricao;
  final String unidade;
  final String curso;
  final String turma;
  final String periodo;
  final String anexoNome;
  final DateTime dataPublicacao;
  final DateTime dataEntrega;
  final int totalAlunos;
  final int entreguesQtd;

  const Trabalho({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.unidade,
    required this.curso,
    required this.turma,
    required this.periodo,
    required this.anexoNome,
    required this.dataPublicacao,
    required this.dataEntrega,
    required this.totalAlunos,
    required this.entreguesQtd,
  });

  int get faltamEntregar => totalAlunos - entreguesQtd;

  factory Trabalho.fromMap(Map<String, dynamic> m) => Trabalho(
        id: m['id']?.toString() ?? '',
        titulo: m['titulo'] ?? '',
        descricao: m['descricao'] ?? '',
        unidade: m['unidade'] ?? '',
        curso: m['curso'] ?? '',
        turma: m['turma'] ?? '',
        periodo: m['periodo'] ?? '',
        anexoNome: m['anexoNome'] ?? '',
        dataPublicacao: DateTime.tryParse(m['dataPublicacao'] ?? '') ?? DateTime.now(),
        dataEntrega: DateTime.tryParse(m['dataEntrega'] ?? '') ?? DateTime.now(),
        totalAlunos: (m['totalAlunos'] as num?)?.toInt() ?? 0,
        entreguesQtd: (m['entreguesQtd'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'descricao': descricao,
        'unidade': unidade,
        'curso': curso,
        'turma': turma,
        'periodo': periodo,
        'anexoNome': anexoNome,
        'dataPublicacao': dataPublicacao.toIso8601String(),
        'dataEntrega': dataEntrega.toIso8601String(),
        'totalAlunos': totalAlunos,
        'entreguesQtd': entreguesQtd,
      };
}
