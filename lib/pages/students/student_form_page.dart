import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/validators.dart';
import '../../providers/student_provider.dart';

class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _cpf = TextEditingController();
  final _email = TextEditingController();
  final _turma = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _cpf.dispose();
    _email.dispose();
    _turma.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final prov = Provider.of<StudentProvider>(context, listen: false);
    if (!_formKey.currentState!.validate()) return;
    try {
      await prov.add(
        name: _name.text.trim(),
        cpf: _cpf.text.trim(),
        email: _email.text.trim(),
        turma: _turma.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aluno cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Aluno')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dados do Aluno (EuroBackend API)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: 'Nome Completo *',
                    controller: _name,
                    validator: (v) => validateRequired(v, message: 'Nome é obrigatório'),
                  ),
                  CustomTextField(
                    label: 'CPF (11 dígitos) *',
                    controller: _cpf,
                    validator: validateCpf,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    label: 'E-mail *',
                    controller: _email,
                    validator: validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomTextField(
                    label: 'Turma / Observação',
                    controller: _turma,
                    validator: (v) => validateRequired(v, message: 'Informe a turma'),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    onPressed: prov.loading ? () {} : _save,
                    label: 'Cadastrar Aluno',
                    loading: prov.loading,
                  ),
                  if (prov.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        prov.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
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