import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/validators.dart';
import '../../providers/student_provider.dart';

class StudentFormPage extends StatefulWidget {
  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}
class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _turma = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _turma.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final prov = Provider.of<StudentProvider>(context, listen: false);
    if (!_formKey.currentState!.validate()) return;
    try {
      await prov.add(name: _name.text.trim(), email: _email.text.trim(), turma: _turma.text.trim());
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<StudentProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Aluno')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(label: 'Nome Completo', controller: _name, validator: (v) => validateRequired(v)),
              CustomTextField(label: 'Email', controller: _email, validator: validateEmail, keyboardType: TextInputType.emailAddress),
              CustomTextField(label: 'Turma', controller: _turma, validator: (v) => validateRequired(v)),
              SizedBox(height: 12),
              PrimaryButton(onPressed: prov.loading ? (){} : _save, label: 'Cadastrar', loading: prov.loading),
              if (prov.error != null) Padding(padding: EdgeInsets.only(top:8), child: Text(prov.error!, style: TextStyle(color: Colors.red))),
            ],
          ),
        ),
      ),
    );
  }
}