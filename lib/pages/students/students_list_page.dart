import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../theme/app_colors.dart';

class StudentsListPage extends StatelessWidget {
  const StudentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<StudentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Sincronizar com a API',
            onPressed: prov.loadAll,
          ),
        ],
      ),
      body: Column(
        children: [
          if (prov.isOfflineData)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: AppColors.accentYellow.withValues(alpha: 0.15),
              child: Row(
                children: [
                  Icon(Icons.offline_pin, color: AppColors.darkBlue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Dados carregados do cache local (SharedPreferences).',
                      style: TextStyle(fontSize: 12, color: AppColors.darkBlue),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: prov.loading && prov.students.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : prov.students.isEmpty
                    ? const Center(
                        child: Text('Nenhum aluno cadastrado. Use o botão + para adicionar.'),
                      )
                    : RefreshIndicator(
                        onRefresh: prov.loadAll,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: prov.students.length,
                          itemBuilder: (ctx, i) {
                            final s = prov.students[i];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.12),
                                  child: Text(
                                    s.name.isNotEmpty ? s.name[0].toUpperCase() : 'A',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        s.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (s.id.startsWith('local-')) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.statusOrange.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: AppColors.statusOrange),
                                        ),
                                        child: const Text(
                                          'não sincronizado',
                                          style: TextStyle(fontSize: 9, color: AppColors.statusOrange),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (s.cpf.isNotEmpty) Text('CPF: ${s.cpf}'),
                                    Text(s.email),
                                    if (s.turma.isNotEmpty) Text('Turma: ${s.turma}'),
                                  ],
                                ),
                                isThreeLine: s.cpf.isNotEmpty,
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.statusRed),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: ctx,
                                      builder: (dCtx) => AlertDialog(
                                        title: const Text('Confirmar exclusão'),
                                        content: Text('Deseja remover "${s.name}"?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(dCtx).pop(false),
                                            child: const Text('Cancelar'),
                                          ),
                                          FilledButton(
                                            style: FilledButton.styleFrom(backgroundColor: AppColors.statusRed),
                                            onPressed: () => Navigator.of(dCtx).pop(true),
                                            child: const Text('Excluir'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      try {
                                        final synced = await prov.remove(s.id);
                                        if (ctx.mounted) {
                                          ScaffoldMessenger.of(ctx).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                synced
                                                    ? 'Aluno removido com sucesso na API'
                                                    : 'Aluno removido apenas localmente (sem conexão com a API agora)',
                                              ),
                                              backgroundColor: synced
                                                  ? AppColors.statusGreen
                                                  : AppColors.statusOrange,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (ctx.mounted) {
                                          ScaffoldMessenger.of(ctx).showSnackBar(
                                            SnackBar(
                                              content: Text(e.toString()),
                                              backgroundColor: AppColors.statusRed,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed('/students/new'),
      ),
    );
  }
}