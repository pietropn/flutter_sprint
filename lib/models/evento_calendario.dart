/// Tipo do evento exibido no calendário, com cor própria (bolinha colorida
/// no dia, conforme o protótipo da tela "Calendário").
enum TipoEvento { aula, trabalho, prova }

extension TipoEventoX on TipoEvento {
  String get label {
    switch (this) {
      case TipoEvento.aula:
        return 'Aula';
      case TipoEvento.trabalho:
        return 'Trabalho';
      case TipoEvento.prova:
        return 'Prova';
    }
  }

  static TipoEvento fromString(String? v) {
    switch (v) {
      case 'trabalho':
        return TipoEvento.trabalho;
      case 'prova':
        return TipoEvento.prova;
      default:
        return TipoEvento.aula;
    }
  }

  String get asString => name;
}

/// Representa um evento no calendário: aula do dia, atribuição de trabalho
/// ou prova, associado a uma turma.
class EventoCalendario {
  final String id;
  final String titulo;
  final DateTime data;
  final String turma;
  final TipoEvento tipo;

  const EventoCalendario({
    required this.id,
    required this.titulo,
    required this.data,
    required this.turma,
    required this.tipo,
  });

  factory EventoCalendario.fromMap(Map<String, dynamic> m) => EventoCalendario(
        id: m['id']?.toString() ?? '',
        titulo: m['titulo'] ?? '',
        data: DateTime.tryParse(m['data'] ?? '') ?? DateTime.now(),
        turma: m['turma'] ?? '',
        tipo: TipoEventoX.fromString(m['tipo']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'data': data.toIso8601String(),
        'turma': turma,
        'tipo': tipo.asString,
      };
}
