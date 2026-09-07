import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/turma_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/donut_chart.dart';
import '../../widgets/section_card.dart';
import '../../widgets/icon_label_card.dart';
import '../turmas/turma_detail_page.dart';
import '../trabalhos/trabalhos_page.dart';
import '../calendario/calendario_page.dart';

/// Home do Professor — réplica da tela "Professor - Turma A" do
/// protótipo: saudação, turma sob responsabilidade, ações rápidas
/// ("Ajuda Coleta" / "Enviar mensagem ao educador") e os três indicadores
/// de engajamento em miniatura, além de atalhos para Trabalhos e Calendário.
class HomeProfessorPage extends StatelessWidget {
  final VoidCallback? onOpenDashboard;
  const HomeProfessorPage({super.key, this.onOpenDashboard});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final turmaProv = Provider.of<TurmaProvider>(context);

    // Busca a turma sob responsabilidade do professor logado (e não
    // simplesmente a primeira turma da lista).
    final minhaTurma = turmaProv.byProfessor(auth.user?.name);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, ${auth.user?.name ?? 'Professor(a)'}!',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (minhaTurma != null)
            Row(
              children: [
                Text(
                  minhaTurma.nome,
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Professor • ${minhaTurma.nome}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: IconLabelCard(
              icon: Icons.school_rounded,
              label: 'Ver Alunos',
              subtitle: 'Lista completa via API REST',
              background: AppColors.surface,
              color: AppColors.primaryBlue,
              textColor: AppColors.textDark,
              onTap: () => Navigator.of(context).pushNamed('/students'),
            ),
          ),
          const SizedBox(height: 16),
          if (minhaTurma == null)
            const SectionCard(
              child: Text(
                'Nenhuma turma foi encontrada para o seu usuário ainda.',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: IconLabelCard(
                    icon: Icons.support_agent,
                    label: 'Ajuda Coleta',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Coleta de dados da turma solicitada.')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: IconLabelCard(
                    icon: Icons.send_rounded,
                    label: 'Enviar mensagem',
                    background: AppColors.surface,
                    color: AppColors.primaryBlue,
                    textColor: AppColors.textDark,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mensagem enviada ao educador responsável.')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Engajamento',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DonutChart(
                    percent: minhaTurma.engajamentoPct,
                    color: AppColors.primaryBlue,
                    label: 'Engajamento',
                    size: 68,
                  ),
                  DonutChart(
                    percent: minhaTurma.faltasPct,
                    color: AppColors.statusRed,
                    label: 'Faltas',
                    size: 68,
                  ),
                  DonutChart(
                    percent: minhaTurma.entregasPct,
                    color: AppColors.statusGreen,
                    label: 'Entregas de\nTrabalho',
                    size: 68,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TurmaDetailPage(turmaId: minhaTurma.id),
                      ),
                    ),
                    child: const Text('Ver desempenho completo'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onOpenDashboard,
                    child: const Text('Dashboard'),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          const Text('Atalhos rápidos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              IconLabelCard(
                icon: Icons.assignment_rounded,
                label: 'Trabalhos',
                subtitle: 'Publicar e acompanhar',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TrabalhosPage()),
                ),
              ),
              IconLabelCard(
                icon: Icons.calendar_month_rounded,
                label: 'Calendário',
                subtitle: 'Aulas, trabalhos e provas',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CalendarioPage()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
