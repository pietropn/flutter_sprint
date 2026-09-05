import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';

class StudentsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<StudentProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Alunos')),
      body: prov.loading
          ? Center(child: CircularProgressIndicator())
          : prov.students.isEmpty
              ? Center(child: Text('Nenhum aluno. Use + para adicionar.'))
              : RefreshIndicator(
                  onRefresh: prov.loadAll,
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: prov.students.length,
                    itemBuilder: (ctx, i) {
                      final s = prov.students[i];
                      return Card(
                        child: ListTile(
                          title: Text(s.name),
                          subtitle: Text('${s.email} • ${s.turma}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              try {
                                await prov.remove(s.id);
                                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Aluno removido')));
                              } catch (e) {
                                ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(e.toString())));
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed('/students/new'),
      ),
    );
  }
}