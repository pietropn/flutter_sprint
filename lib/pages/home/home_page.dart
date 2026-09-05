import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../widgets/loading_overlay.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final students = Provider.of<StudentProvider>(context, listen: false);
    students.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final students = Provider.of<StudentProvider>(context);
    return LoadingOverlay(
      loading: students.loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Euro Tech!'),
          actions: [
            IconButton(icon: Icon(Icons.logout), onPressed: () async {
              await auth.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            })
          ],
        ),
        body: Center(child: Text('Olá, ${auth.user?.name ?? 'Usuário'}\nUse o botão de "Turmas" para ver alunos.', textAlign: TextAlign.center)),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.group),
          onPressed: () => Navigator.of(context).pushNamed('/students'),
        ),
      ),
    );
  }
}