import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/turma_provider.dart';
import '../../services/preferences_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/validators.dart';

/// Réplica da tela "Cadastro Aluno" do protótipo.
///
/// Os campos nome/CPF/e-mail/turma são enviados para a API REST do
/// projeto (recurso /alunos). Os demais campos do protótipo (endereço,
/// RG, responsável, etc.) ainda não são suportados pela API — por isso
/// são salvos localmente no SharedPreferences como "ficha complementar",
/// mantendo a fidelidade visual com o protótipo sem inventar dados na API.
class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _cpf = TextEditingController();
  final _estado = TextEditingController();
  final _cidade = TextEditingController();
  final _cep = TextEditingController();
  final _numero = TextEditingController();
  final _email = TextEditingController();
  final _telefone = TextEditingController();
  final _responsavel = TextEditingController();
  final _nascimento = TextEditingController();
  final _raca = TextEditingController();
  final _genero = TextEditingController();
  final _rg = TextEditingController();
  final _curso = TextEditingController();
  final _periodo = TextEditingController();
  String? _turmaSelecionada;
  String _statusEstudante = 'Ativo';
  bool _fotoAdicionada = false;

  @override
  void dispose() {
    for (final c in [
      _name, _cpf, _estado, _cidade, _cep, _numero, _email, _telefone,
      _responsavel, _nascimento, _raca, _genero, _rg, _curso, _periodo,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final prov = Provider.of<StudentProvider>(context, listen: false);
    if (!_formKey.currentState!.validate()) return;
    try {
      final synced = await prov.add(
        name: _name.text.trim(),
        cpf: _cpf.text.trim(),
        email: _email.text.trim(),
        turma: _turmaSelecionada ?? '',
      );

      // Ficha complementar (campos do protótipo não suportados pela API)
      await PreferencesService.instance.saveFichaAluno(_email.text.trim(), {
        'estado': _estado.text.trim(),
        'cidade': _cidade.text.trim(),
        'cep': _cep.text.trim(),
        'numero': _numero.text.trim(),
        'telefone': _telefone.text.trim(),
        'responsavel': _responsavel.text.trim(),
        'nascimento': _nascimento.text.trim(),
        'raca': _raca.text.trim(),
        'genero': _genero.text.trim(),
        'rg': _rg.text.trim(),
        'curso': _curso.text.trim(),
        'periodo': _periodo.text.trim(),
        'status': _statusEstudante,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              synced
                  ? 'Aluno cadastrado com sucesso na API!'
                  : 'Sem conexão com a API agora — aluno salvo localmente '
                      '(cache) e será exibido normalmente no app.',
            ),
            backgroundColor: synced ? AppColors.statusGreen : AppColors.statusOrange,
            duration: Duration(seconds: synced ? 3 : 5),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar: $e'), backgroundColor: AppColors.statusRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<StudentProvider>(context);
    final turmaProv = Provider.of<TurmaProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro dos alunos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: 'Nome Completo *',
                    controller: _name,
                    validator: (v) => validateRequired(v, message: 'Nome é obrigatório'),
                  ),
                  CustomTextField(label: 'CPF (11 dígitos) *', controller: _cpf, validator: validateCpf),
                  Row(
                    children: [
                      Expanded(child: CustomTextField(label: 'Estado', controller: _estado)),
                      const SizedBox(width: 10),
                      Expanded(flex: 2, child: CustomTextField(label: 'Cidade', controller: _cidade)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: CustomTextField(label: 'CEP', controller: _cep)),
                      const SizedBox(width: 10),
                      Expanded(child: CustomTextField(label: 'Número', controller: _numero)),
                    ],
                  ),
                  CustomTextField(
                    label: 'E-mail *',
                    controller: _email,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomTextField(label: 'Telefone', controller: _telefone, keyboardType: TextInputType.phone),
                  CustomTextField(label: 'Nome do responsável', controller: _responsavel),
                  CustomTextField(label: 'Data de Nascimento', controller: _nascimento),
                  CustomTextField(label: 'Raça', controller: _raca),
                  CustomTextField(label: 'Gênero', controller: _genero),
                  CustomTextField(label: 'RG', controller: _rg),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _turmaSelecionada,
                    decoration: const InputDecoration(labelText: 'Turma *'),
                    items: turmaProv.turmas
                        .map((t) => DropdownMenuItem(value: t.nome, child: Text(t.nome)))
                        .toList(),
                    onChanged: (v) => setState(() => _turmaSelecionada = v),
                    validator: (v) => v == null ? 'Selecione a turma' : null,
                  ),
                  CustomTextField(label: 'Curso', controller: _curso),
                  CustomTextField(label: 'Período', controller: _periodo),
                  const SizedBox(height: 4),
                  const Text('Status do Estudante', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  Wrap(
                    spacing: 8,
                    children: ['Ativo', 'Trancado', 'Formado']
                        .map((s) => ChoiceChip(
                              label: Text(s),
                              selected: _statusEstudante == s,
                              onSelected: (_) => setState(() => _statusEstudante = s),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => setState(() => _fotoAdicionada = true),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD9DEE7)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _fotoAdicionada ? Icons.check_circle : Icons.upload_rounded,
                            color: _fotoAdicionada ? AppColors.statusGreen : AppColors.textMuted,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _fotoAdicionada ? 'Foto adicionada' : 'Adicionar foto do aluno',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                          const Text(
                            'Formato do arquivo: JPG, JPEG, PNG. O tamanho da imagem de foto do aluno\nnão deve exceder 10MB.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    onPressed: prov.loading ? () {} : _save,
                    label: 'CADASTRAR',
                    loading: prov.loading,
                  ),
                  if (prov.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(prov.error!, style: const TextStyle(color: AppColors.statusRed)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
