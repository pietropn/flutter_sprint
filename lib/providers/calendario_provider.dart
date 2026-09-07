import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/evento_calendario.dart';
import '../services/academic_local_service.dart';

/// Provider do Calendário (aulas, trabalhos e provas), persistido localmente.
class CalendarioProvider with ChangeNotifier {
  final AcademicLocalService _service = AcademicLocalService.instance;
  List<EventoCalendario> _eventos = [];

  CalendarioProvider() {
    _eventos = _service.getEventos();
  }

  List<EventoCalendario> get eventos => List.unmodifiable(_eventos);

  List<EventoCalendario> eventosDoDia(DateTime dia) {
    return _eventos
        .where((e) => e.data.year == dia.year && e.data.month == dia.month && e.data.day == dia.day)
        .toList();
  }

  Future<void> adicionarEvento({
    required String titulo,
    required DateTime data,
    required String turma,
    required TipoEvento tipo,
  }) async {
    _eventos.add(
      EventoCalendario(id: const Uuid().v4(), titulo: titulo, data: data, turma: turma, tipo: tipo),
    );
    await _service.saveEventos(_eventos);
    notifyListeners();
  }
}
