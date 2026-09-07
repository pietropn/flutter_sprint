import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trabalho_provider.dart';
import '../../providers/turma_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/validators.dart';

/// Réplica da tela "Trabalhos" do protótipo: formulário para publicar um
/// novo trabalho e lista dos trabalhos já publicados com o total de
/// entregas recebidas.
class TrabalhosPage extends StatefulWidget {
  const TrabalhosPage({super.key});

  @override
  State<TrabalhosPage> createState() => _TrabalhosPageState();
}

class _TrabalhosPageState extends State<TrabalhosPage> {
  final _formKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _descricao = TextEditingController();
  final _unidade = TextEditingController();
  final _curso = TextEditingController();
  String? _turmaSelecionada;
  final _periodo = TextEditingController();
  String? _anexoNome;

  @override
  void dispose() {
    _titulo.dispose();
    _descricao.dispose();
    _unidade.dispose();
    _curso.dispose();
    _periodo.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    final prov = Provider.of<TrabalhoProvider>(context, listen: false);
    try {
      await prov.publicar(
        titulo: _titulo.text.trim(),
        descricao: _descricao.text.trim(),
        unidade: _unidade.text.trim(),
        curso: _curso.text.trim(),
        turma: _turmaSelecionada ?? '',
        periodo: _periodo.text.trim(),
        anexoNome: _anexoNome ?? '',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trabalho publicado com sucesso!'),
            backgroundColor: AppColors.statusGreen,
          ),
        );
        _formKey.currentState!.reset();
        _titulo.clear();
        _descricao.clear();
        _unidade.clear();
        _curso.clear();
        _periodo.clear();
        setState(() {
          _turmaSelecionada = null;
          _anexoNome = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao publicar: $e'), backgroundColor: AppColors.statusRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trabalhoProv = Provider.of<TrabalhoProvider>(context);
    final turmaProv = Provider.of<TurmaProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Trabalhos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Publicar trabalho',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    CustomTextField(
                      label: 'Título do trabalho *',
                      controller: _titulo,
                      validator: (v) => validateRequired(v, message: 'Informe o título'),
                    ),
                    CustomTextField(
                      label: 'Descrição do trabalho *',
                      controller: _descricao,
                      validator: (v) => validateRequired(v, message: 'Informe a descrição'),
                    ),
                    CustomTextField(label: 'Unidade', controller: _unidade),
                    CustomTextField(label: 'Curso', controller: _curso),
                    DropdownButtonFormField<String>(
                      value: _turmaSelecionada,
                      decoration: const InputDecoration(labelText: 'Turma *'),
                      items: turmaProv.turmas
                          .map((t) => DropdownMenuItem(value: t.nome, child: Text(t.nome)))
                          .toList(),
                      onChanged: (v) => setState(() => _turmaSelecionada = v),
                      validator: (v) => v == null ? 'Selecione a turma' : null,
                    ),
                    CustomTextField(label: 'Período', controller: _periodo),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _anexoNome = 'anexo_trabalho.pdf'),
                      icon: const Icon(Icons.attach_file),
                      label: Text(_anexoNome ?? 'Anexar arquivo'),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      onPressed: trabalhoProv.loading ? () {} : _enviar,
                      label: 'Enviar trabalho',
                      loading: trabalhoProv.loading,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Trabalhos publicados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          if (trabalhoProv.trabalhos.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('Nenhum trabalho publicado ainda.',
                  style: TextStyle(color: AppColors.textMuted)),
            )
          else
            ...trabalhoProv.trabalhos.map(
              (t) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(t.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Turma ${t.turma} • Entregues: ${t.entreguesQtd}/${t.totalAlunos}\n'
                    'Faltam entregar: ${t.faltamEntregar} alunos',
                  ),
                  isThreeLine: true,
                  trailing: Text(
                    'Entrega\n${t.dataEntrega.day.toString().padLeft(2, '0')}/'
                    '${t.dataEntrega.month.toString().padLeft(2, '0')}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
