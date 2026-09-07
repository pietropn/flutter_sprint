import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/role.dart';
import '../theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/student_provider.dart';
import '../pages/home/home_gestor_page.dart';
import '../pages/home/home_professor_page.dart';
import '../pages/turmas/turmas_list_page.dart';
import '../pages/platforms/plataformas_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/teachers/professor_form_page.dart';
import 'euro_bottom_nav.dart';
import 'euro_tech_logo.dart';
import 'loading_overlay.dart';

/// Shell principal do app pós-login: barra de navegação inferior fixa
/// (Home, Turmas, Plataformas, Dashboard), replicando a estrutura de
/// navegação presente em todas as telas do protótipo da Sprint 2.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentProvider>(context, listen: false).loadAll();
    });
  }

  void _irParaDashboard() => setState(() => _tab = 3);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final students = Provider.of<StudentProvider>(context);
    final isGestor = (auth.user?.role ?? Role.gestor) == Role.gestor;

    return LoadingOverlay(
      loading: students.loading && students.students.isEmpty,
      child: Scaffold(
        body: IndexedStack(
          index: _tab,
          children: [
            Scaffold(
              appBar: AppBar(
                title: const EuroTechWordmark(),
                actions: [_AcessosMenu(isGestor: isGestor, auth: auth)],
              ),
              body: isGestor
                  ? HomeGestorPage(onOpenDashboard: _irParaDashboard)
                  : HomeProfessorPage(onOpenDashboard: _irParaDashboard),
            ),
            Scaffold(
              appBar: AppBar(
                title: const EuroTechWordmark(),
                actions: [_AcessosMenu(isGestor: isGestor, auth: auth)],
              ),
              body: const TurmasListPage(),
            ),
            const PlataformasPage(),
            const DashboardPage(),
          ],
        ),
        bottomNavigationBar: EuroBottomNav(
          currentIndex: _tab,
          onTap: (i) => setState(() => _tab = i),
        ),
      ),
    );
  }
}

/// Menu de acesso a Configurações, Cadastro de Professor (Gestor) e Sair.
/// Usa rótulos de texto (não depende apenas do glifo do ícone), garantindo
/// que o Gestor e o Professor sempre consigam navegar para essas telas
/// mesmo se a fonte de ícones do Material não carregar corretamente.
class _AcessosMenu extends StatelessWidget {
  final bool isGestor;
  final AuthProvider auth;
  const _AcessosMenu({required this.isGestor, required this.auth});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu_rounded),
      tooltip: 'Mais opções',
      onSelected: (value) async {
        switch (value) {
          case 'alunos':
            Navigator.of(context).pushNamed('/students');
            break;
          case 'settings':
            Navigator.of(context).pushNamed('/settings');
            break;
          case 'professor':
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfessorFormPage()),
            );
            break;
          case 'logout':
            await auth.logout();
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
            }
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'alunos',
          child: ListTile(
            leading: Icon(Icons.school_rounded),
            title: Text('Alunos (API)'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (isGestor)
          const PopupMenuItem(
            value: 'professor',
            child: ListTile(
              leading: Icon(Icons.person_add_alt_1),
              title: Text('Cadastrar professor'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: const Icon(Icons.logout, color: AppColors.statusRed),
            title: const Text('Sair', style: TextStyle(color: AppColors.statusRed, fontWeight: FontWeight.bold)),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
