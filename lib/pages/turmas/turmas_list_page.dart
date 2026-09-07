import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/turma_provider.dart';
import '../../theme/app_colors.dart';
import 'turma_detail_page.dart';

/// Aba "Turmas": lista todas as turmas com seus indicadores resumidos.
class TurmasListPage extends StatelessWidget {
  const TurmasListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final turmaProv = Provider.of<TurmaProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Turmas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
            'Acompanhe o engajamento de cada turma',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: turmaProv.turmas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final t = turmaProv.turmas[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryBlue,
                      child: Text(
                        t.nome.isNotEmpty ? t.nome.substring(t.nome.length - 1) : '?',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(t.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Engajamento ${t.engajamentoPct}% • Faltas ${t.faltasPct}% • Entregas ${t.entregasPct}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TurmaDetailPage(turmaId: t.id)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
