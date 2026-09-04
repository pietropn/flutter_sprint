import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/custom_text_field.dart';
import '../../services/storage_service.dart';
import '../../models/student.dart';
import '../../utils/validators.dart';

class StudentFormPage extends StatefulWidget {
  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _turmaCtrl = TextEditingController();
  bool _saving = false;
  String? _error;

  Future<void> _save() async {
    setState(() {
      _error = null;
    });
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final storage = Provider.of<StorageService>(context, listen: false);
      final student = Student(
        id: Uuid().v4(),
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        turma: _turmaCtrl.text.trim(),
      );
      await storage.addStudent(student);
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _turmaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Aluno'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(label: 'Nome Completo', controller: _nameCtrl, validator: (v) => validateRequired(v)),
              CustomTextField(label: 'Email', controller: _emailCtrl, keyboardType: TextInputType.emailAddress, validator: validateEmail),
              CustomTextField(label: 'Turma', controller: _turmaCtrl, validator: (v) => validateRequired(v)),
              if (_error != null) Text(_error!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving ? CircularProgressIndicator(color: Colors.white) : Text('Cadastrar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}