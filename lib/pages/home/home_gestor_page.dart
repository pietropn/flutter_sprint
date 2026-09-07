import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/turma_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/section_card.dart';
import '../../widgets/icon_label_card.dart';
import '../turmas/turma_detail_page.dart';

/// Réplica da tela "Home Gestor" do protótipo: saudação, cartão de
/// dashboard geral, filtros de turno, relatório básico e grade de turmas.
class HomeGestorPage extends StatefulWidget {
  final VoidCallback? onOpenDashboard;
  const HomeGestorPage({super.key, this.onOpenDashboard});

  @override
  State<HomeGestorPage> createState() => _HomeGestorPageState();
}

class _HomeGestorPageState extends State<HomeGestorPage> {
  bool _turnoManha = true;
  bool _turnoTarde = true;
  bool _turnoNoite = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final turmaProv = Provider.of<TurmaProvider>(context);
    final studentProv = Provider.of<StudentProvider>(context);

    final turmas = turmaProv.turmas;
    final engajamentoMedio = turmas.isEmpty
        ? 0
        : (turmas.map((t) => t.engajamentoPct).reduce((a, b) => a + b) / turmas.length).round();
    final turmasEmAlerta = turmas.where((t) => t.faltasPct >= 25).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Olá, ${auth.user?.name ?? 'Gestor(a)'}!',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Principais informações para o Gestor',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.dashboard_rounded, color: AppColors.accentYellow, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Dashboard Geral',
                      style: TextStyle(
                        color: AppColors.accentYellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Engajamento dos alunos\ndescrição: Aulas do dia de hoje',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.onOpenDashboard,
                    icon: const Icon(Icons.bar_chart_rounded, size: 18),
                    label: const Text('Ver Dashboard'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: IconLabelCard(
              icon: Icons.school_rounded,
              label: 'Gerenciar Alunos',
              subtitle: 'Cadastro e listagem via API REST',
              background: AppColors.surface,
              color: AppColors.primaryBlue,
              textColor: AppColors.textDark,
              onTap: () => Navigator.of(context).pushNamed('/students'),
            ),
          ),

          // ---------------------------------------------------------------
          // Relatório básico: visão geral rápida para o Gestor, combinando
          // dados das turmas (locais) com os alunos reais vindos da API.
          // ---------------------------------------------------------------
          SectionCard(
            title: 'Relatório básico',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ReportStat(
                        icon: Icons.groups_rounded,
                        value: '${turmas.length}',
                        label: 'Turmas ativas',
                      ),
                    ),
                    Expanded(
                      child: _ReportStat(
                        icon: Icons.school_rounded,
                        value: '${studentProv.students.length}',
                        label: 'Alunos cadastrados',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ReportStat(
                        icon: Icons.trending_up_rounded,
                        value: '$engajamentoMedio%',
                        label: 'Engajamento médio',
                        color: AppColors.statusGreen,
                      ),
                    ),
                    Expanded(
                      child: _ReportStat(
                        icon: Icons.warning_amber_rounded,
                        value: '$turmasEmAlerta',
                        label: 'Turmas em alerta\n(faltas ≥ 25%)',
                        color: turmasEmAlerta > 0 ? AppColors.statusRed : AppColors.statusGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text('Turnos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          _turnoCheck(Icons.wb_sunny_rounded, 'Turno da manhã', _turnoManha,
              (v) => setState(() => _turnoManha = v)),
          _turnoCheck(Icons.wb_cloudy_rounded, 'Turno da tarde', _turnoTarde,
              (v) => setState(() => _turnoTarde = v)),
          _turnoCheck(Icons.nights_stay_rounded, 'Turno da noite', _turnoNoite,
              (v) => setState(() => _turnoNoite = v)),
          const SizedBox(height: 8),
          const Text('Turmas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: turmas
                .map(
                  (t) => _TurmaButton(
                    nome: t.nome,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TurmaDetailPage(turmaId: t.id)),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.statusRed,
                side: const BorderSide(color: AppColors.statusRed),
              ),
              onPressed: () async {
                await auth.logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sair da conta'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _turnoCheck(IconData icon, String label, bool value, ValueChanged<bool> onChanged) {
    return SectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        secondary: Icon(icon, color: AppColors.primaryBlue, size: 20),
        title: Text(label, style: const TextStyle(fontSize: 13)),
        value: value,
        onChanged: (v) => onChanged(v ?? false),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

class _ReportStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? color;
  const _ReportStat({required this.icon, required this.value, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primaryBlue;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: c, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: c)),
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ),
      ],
    );
  }
}

class _TurmaButton extends StatelessWidget {
  final String nome;
  final VoidCallback onTap;
  const _TurmaButton({required this.nome, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryBlue,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.groups_rounded, color: AppColors.accentYellow, size: 22),
            const SizedBox(height: 6),
            Text(
              nome,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
