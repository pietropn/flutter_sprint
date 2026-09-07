import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/turma_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/status_badge.dart';

/// Réplica da tela "Plataformas" do protótipo: lista de cursos/plataformas
/// (ex.: "Curso de Excel") com busca, filtro por turma e tabela de alunos
/// com status de presença. Reaproveita os alunos reais vindos da API,
/// já que a API do projeto não expõe um recurso de "plataformas".
class PlataformasPage extends StatefulWidget {
  const PlataformasPage({super.key});

  @override
  State<PlataformasPage> createState() => _PlataformasPageState();
}

class _PlataformasPageState extends State<PlataformasPage> {
  static const _cursos = ['Curso de Excel', 'Curso de Power BI', 'Curso de Lógica de Programação'];
  String _cursoSelecionado = _cursos.first;
  String _busca = '';
  String? _turmaFiltro;

  @override
  Widget build(BuildContext context) {
    final studentProv = Provider.of<StudentProvider>(context);
    final turmaProv = Provider.of<TurmaProvider>(context);

    final alunosFiltrados = studentProv.students.where((s) {
      final matchBusca = _busca.isEmpty || s.name.toLowerCase().contains(_busca.toLowerCase());
      final matchTurma = _turmaFiltro == null || _turmaFiltro!.isEmpty || s.turma == _turmaFiltro;
      return matchBusca && matchTurma;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Plataformas')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _cursos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (ctx, i) {
                      final curso = _cursos[i];
                      final selecionado = curso == _cursoSelecionado;
                      return ChoiceChip(
                        label: Text(curso),
                        selected: selecionado,
                        onSelected: (_) => setState(() => _cursoSelecionado = curso),
                        selectedColor: AppColors.primaryBlue,
                        labelStyle: TextStyle(
                          color: selecionado ? Colors.white : AppColors.textDark,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, size: 20),
                          hintText: 'Buscar aluno',
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() => _busca = v),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _turmaFiltro,
                        decoration: const InputDecoration(hintText: 'Turma', isDense: true),
                        items: [
                          const DropdownMenuItem(value: '', child: Text('Todas')),
                          ...turmaProv.turmas
                              .map((t) => DropdownMenuItem(value: t.nome, child: Text(t.nome))),
                        ],
                        onChanged: (v) => setState(() => _turmaFiltro = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (studentProv.loading && alunosFiltrados.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (alunosFiltrados.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'Nenhum aluno encontrado para este filtro.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Nome')),
                      DataColumn(label: Text('Turma')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Presença')),
                    ],
                    rows: alunosFiltrados.asMap().entries.map((entry) {
                      final s = entry.value;
                      // Presença simulada de forma determinística a partir do índice,
                      // já que a API do projeto não expõe esse dado ainda.
                      final presente = entry.key % 4 != 0;
                      return DataRow(cells: [
                        DataCell(Text(s.name, overflow: TextOverflow.ellipsis)),
                        DataCell(Text(s.turma.isEmpty ? '—' : s.turma)),
                        DataCell(Text(s.email, overflow: TextOverflow.ellipsis)),
                        DataCell(
                          StatusBadge(
                            text: presente ? 'Presente' : 'Ausente',
                            color: presente ? AppColors.statusGreen : AppColors.statusRed,
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
