import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/professor.dart';
import '../../providers/professor_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/validators.dart';

/// Réplica da tela "Cadastro Professor" do protótipo. Persistido
/// localmente (SharedPreferences), já que a API do projeto ainda não
/// expõe um endpoint de professores.
class ProfessorFormPage extends StatefulWidget {
  const ProfessorFormPage({super.key});

  @override
  State<ProfessorFormPage> createState() => _ProfessorFormPageState();
}

class _ProfessorFormPageState extends State<ProfessorFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _cpf = TextEditingController();
  final _estado = TextEditingController();
  final _cidade = TextEditingController();
  final _cep = TextEditingController();
  final _numero = TextEditingController();
  final _email = TextEditingController();
  final _telefone = TextEditingController();
  final _nascimento = TextEditingController();
  final _raca = TextEditingController();
  final _genero = TextEditingController();
  final _rg = TextEditingController();
  final _unidade = TextEditingController();
  final _contrato = TextEditingController();
  String _status = 'Ativo';
  bool _fotoAdicionada = false;

  @override
  void dispose() {
    for (final c in [
      _nome, _cpf, _estado, _cidade, _cep, _numero, _email,
      _telefone, _nascimento, _raca, _genero, _rg, _unidade, _contrato,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final prov = Provider.of<ProfessorProvider>(context, listen: false);
    try {
      await prov.add(
        Professor(
          id: '',
          nomeCompleto: _nome.text.trim(),
          cpf: _cpf.text.trim(),
          estado: _estado.text.trim(),
          cidade: _cidade.text.trim(),
          cep: _cep.text.trim(),
          numero: _numero.text.trim(),
          email: _email.text.trim(),
          telefone: _telefone.text.trim(),
          dataNascimento: _nascimento.text.trim(),
          raca: _raca.text.trim(),
          genero: _genero.text.trim(),
          rg: _rg.text.trim(),
          statusProfessor: _status,
          unidade: _unidade.text.trim(),
          contrato: _contrato.text.trim(),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Professor cadastrado com sucesso!'),
            backgroundColor: AppColors.statusGreen,
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
    final prov = Provider.of<ProfessorProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro dos professores')),
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
                    controller: _nome,
                    validator: (v) => validateRequired(v, message: 'Nome é obrigatório'),
                  ),
                  CustomTextField(label: 'CPF *', controller: _cpf, validator: validateCpf),
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
                  CustomTextField(label: 'Data de Nascimento', controller: _nascimento),
                  CustomTextField(label: 'Raça', controller: _raca),
                  CustomTextField(label: 'Gênero', controller: _genero),
                  CustomTextField(label: 'RG', controller: _rg),
                  const SizedBox(height: 4),
                  const Text('Status do Professor', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  Wrap(
                    spacing: 8,
                    children: ['Ativo', 'Afastado', 'Desligado']
                        .map((s) => ChoiceChip(
                              label: Text(s),
                              selected: _status == s,
                              onSelected: (_) => setState(() => _status = s),
                            ))
                        .toList(),
                  ),
                  CustomTextField(label: 'Unidade', controller: _unidade),
                  CustomTextField(label: 'Contrato', controller: _contrato),
                  const SizedBox(height: 8),
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
                            _fotoAdicionada ? 'Foto adicionada' : 'Adicionar foto do professor',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    onPressed: prov.loading ? () {} : _salvar,
                    label: 'CADASTRAR',
                    loading: prov.loading,
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
