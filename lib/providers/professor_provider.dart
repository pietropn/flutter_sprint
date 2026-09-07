import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/professor.dart';
import '../services/academic_local_service.dart';

/// Provider de Professores (persistência local via SharedPreferences),
/// já que a API do projeto ainda não expõe um endpoint de professores.
class ProfessorProvider with ChangeNotifier {
  final AcademicLocalService _service = AcademicLocalService.instance;
  List<Professor> _professores = [];
  bool _loading = false;

  ProfessorProvider() {
    _professores = _service.getProfessores();
  }

  bool get loading => _loading;
  List<Professor> get professores => List.unmodifiable(_professores);

  Future<void> add(Professor dadosParciais) async {
    _loading = true;
    notifyListeners();

    final novo = Professor(
      id: const Uuid().v4(),
      nomeCompleto: dadosParciais.nomeCompleto,
      cpf: dadosParciais.cpf,
      estado: dadosParciais.estado,
      cidade: dadosParciais.cidade,
      cep: dadosParciais.cep,
      numero: dadosParciais.numero,
      email: dadosParciais.email,
      telefone: dadosParciais.telefone,
      dataNascimento: dadosParciais.dataNascimento,
      raca: dadosParciais.raca,
      genero: dadosParciais.genero,
      rg: dadosParciais.rg,
      statusProfessor: dadosParciais.statusProfessor,
      unidade: dadosParciais.unidade,
      contrato: dadosParciais.contrato,
    );

    _professores.add(novo);
    await _service.saveProfessores(_professores);

    _loading = false;
    notifyListeners();
  }
}
