import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/role.dart';
import '../../providers/auth_provider.dart';
import '../../providers/turma_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bar_chart_simple.dart';
import '../../widgets/donut_chart.dart';
import '../../widgets/line_chart_simple.dart';
import '../../widgets/section_card.dart';
import '../turmas/turma_detail_page.dart';

/// Réplica das telas "Dashboard": visão do Gestor com gráficos agregados
/// (linha de faltas por mês, turmas com mais/menos frequência) e visão do
/// Professor com o desempenho detalhado da própria turma.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isGestor = (auth.user?.role ?? Role.gestor) == Role.gestor;

    // Para o Professor, a tela de detalhe da turma já é o próprio dashboard
    // do protótipo ("Dashboard de acompanhamento"), com seu próprio AppBar.
    if (!isGestor) {
      final turmaProv = Provider.of<TurmaProvider>(context);
      final turma = turmaProv.byProfessor(auth.user?.name);
      if (turma == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Dashboard')),
          body: const Center(child: Text('Nenhuma turma atribuída.')),
        );
      }
      return TurmaDetailPage(turmaId: turma.id);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const _DashboardGestor(),
    );
  }
}

class _DashboardGestor extends StatelessWidget {
  const _DashboardGestor();

  @override
  Widget build(BuildContext context) {
    final turmaProv = Provider.of<TurmaProvider>(context);
    final turmas = turmaProv.turmas;

    final engajamentoMedio = turmas.isEmpty
        ? 0
        : (turmas.map((t) => t.engajamentoPct).reduce((a, b) => a + b) / turmas.length).round();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: 'Total de faltas — últimos 6 meses',
          child: const SimpleLineChart(values: [120, 98, 140, 110, 90, 75]),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Engajamento médio geral',
          child: Center(
            child: DonutChart(percent: engajamentoMedio, color: AppColors.primaryBlue, label: 'Engajamento'),
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Turmas com mais frequência',
          child: SimpleBarChart(
            items: turmas
                .map((t) => BarChartItem(
                      label: t.nome,
                      value: (100 - t.faltasPct).toDouble(),
                      color: AppColors.statusGreen,
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Turmas com baixa frequência',
          child: SimpleBarChart(
            items: turmas
                .where((t) => t.faltasPct >= 20)
                .map((t) => BarChartItem(label: t.nome, value: t.faltasPct.toDouble(), color: AppColors.statusRed))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Turmas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        ...turmas.map(
          (t) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(t.nome),
              subtitle: Text('Engajamento ${t.engajamentoPct}% • Faltas ${t.faltasPct}%'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TurmaDetailPage(turmaId: t.id)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

