import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/turma.dart';
import '../../providers/turma_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/donut_chart.dart';
import '../../widgets/status_badge.dart';

/// Réplica da tela "Turma" / "Dashboard de acompanhamento" do protótipo:
/// três donuts (Engajamento, Faltas, Entregas de Trabalho) e a lista de
/// alunos da turma com média, faltas, ocorrências e ações rápidas.
class TurmaDetailPage extends StatelessWidget {
  final String turmaId;
  const TurmaDetailPage({super.key, required this.turmaId});

  @override
  Widget build(BuildContext context) {
    final turmaProv = Provider.of<TurmaProvider>(context);
    final turma = turmaProv.byId(turmaId);

    if (turma == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Turma')),
        body: const Center(child: Text('Turma não encontrada.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(turma.nome)),
      body: TurmaDetailContent(turmaId: turmaId),
    );
  }
}

/// Conteúdo da tela de Turma sem Scaffold próprio, para ser reaproveitado
/// dentro do shell de navegação (ex.: aba Dashboard do Professor).
class TurmaDetailContent extends StatelessWidget {
  final String turmaId;
  const TurmaDetailContent({super.key, required this.turmaId});

  @override
  Widget build(BuildContext context) {
    final turmaProv = Provider.of<TurmaProvider>(context);
    final turma = turmaProv.byId(turmaId);

    if (turma == null) {
      return const Center(child: Text('Turma não encontrada.'));
    }

    return RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Engajamento',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DonutChart(
                      percent: turma.engajamentoPct,
                      color: AppColors.primaryBlue,
                      label: 'Engajamento',
                    ),
                    DonutChart(
                      percent: turma.faltasPct,
                      color: AppColors.statusRed,
                      label: 'Faltas',
                    ),
                    DonutChart(
                      percent: turma.entregasPct,
                      color: AppColors.statusGreen,
                      label: 'Entregas de\nTrabalho',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Alunos (${turma.alunos.length})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            if (turma.alunos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'Nenhum aluno com dados de desempenho cadastrados\npara esta turma ainda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ...turma.alunos.map((a) => _AlunoTile(turmaId: turma.id, aluno: a)),
          ],
        ),
      );
  }
}

class _AlunoTile extends StatelessWidget {
  final String turmaId;
  final TurmaAluno aluno;
  const _AlunoTile({required this.turmaId, required this.aluno});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    aluno.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Text('Média ${aluno.media.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(width: 8),
                StatusBadge.fromEngajamento(aluno.status),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                _infoChip('Total de faltas', '${aluno.faltas}'),
                _infoChip('Ocorrências', '${aluno.ocorrencias}'),
                _infoChip('Notas baixas', '${aluno.notasBaixasPct}%'),
                _infoChip('Trabalhos entregues', '${aluno.trabalhosEntreguesPct}%'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await Provider.of<TurmaProvider>(context, listen: false)
                          .marcarOcorrencia(turmaId, aluno.nome);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ocorrência registrada para ${aluno.nome}.')),
                        );
                      }
                    },
                    child: const Text('Marcar ocorrência', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mensagem enviada para o responsável por ${aluno.nome}.')),
                      );
                    },
                    child: const Text('Entrar em contato', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
