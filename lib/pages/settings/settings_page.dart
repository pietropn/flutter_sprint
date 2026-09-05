import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/preferences_service.dart';

/// Tela de Configurações e Preferências locais do App.
///
/// Atende diretamente ao critério de avaliação:
/// - Salvar configurações (URL base da API personalizada)
/// - Armazenar preferências (Tema escuro/claro e Lembrar dados)
/// - Gerenciamento de persistência e cache
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _prefs = PreferencesService.instance;
  late final TextEditingController _apiUrlCtrl;

  @override
  void initState() {
    super.initState();
    _apiUrlCtrl = TextEditingController(text: _prefs.getApiUrl());
  }

  @override
  void dispose() {
    _apiUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveApiUrl() async {
    final url = _apiUrlCtrl.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A URL não pode ser vazia')),
      );
      return;
    }

    await _prefs.setApiUrl(url);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL da API salva com sucesso no SharedPreferences!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _clearCache() async {
    await _prefs.clearCachedStudents();
    if (mounted) {
      final studentProv = Provider.of<StudentProvider>(context, listen: false);
      await studentProv.loadAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cache local limpo com sucesso!'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);
    final cachedCount = _prefs.getCachedStudents().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações e Persistência'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. CONFIGURAÇÕES DA API (Salvar configurações)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.dns, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      const Text(
                        'Configuração da API (Backend)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Define a URL base da API do Spring Boot. '
                    'Esta configuração é salva no SharedPreferences e recuperada a cada inicialização.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _apiUrlCtrl,
                    decoration: const InputDecoration(
                      labelText: 'URL Base da API',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      ActionChip(
                        label: const Text('Localhost (8080)'),
                        onPressed: () {
                          setState(() => _apiUrlCtrl.text = 'http://localhost:8080');
                        },
                      ),
                      ActionChip(
                        label: const Text('Emulador Android (10.0.2.2:8080)'),
                        onPressed: () {
                          setState(() => _apiUrlCtrl.text = 'http://10.0.2.2:8080');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveApiUrl,
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar Configuração de URL'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. PREFERÊNCIAS DO APLICATIVO (Armazenar preferências)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.palette, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      const Text(
                        'Preferências do Usuário',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Tema Escuro (Dark Mode)'),
                    subtitle: const Text('Preferência persistida no SharedPreferences'),
                    value: themeProv.isDarkMode,
                    onChanged: (val) => themeProv.toggleTheme(),
                    secondary: Icon(themeProv.isDarkMode ? Icons.dark_mode : Icons.light_mode),
                  ),
                  SwitchListTile(
                    title: const Text('Lembrar E-mail no Login'),
                    subtitle: Text(
                      authProv.savedEmail != null && authProv.savedEmail!.isNotEmpty
                          ? 'E-mail salvo: ${authProv.savedEmail}'
                          : 'Nenhum e-mail salvo',
                    ),
                    value: authProv.rememberEmail,
                    onChanged: (val) async {
                      await _prefs.setRememberEmail(val);
                      setState(() {});
                    },
                    secondary: const Icon(Icons.remember_me),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. CACHE LOCAL DE DADOS (Cache simples de dados)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.storage, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      const Text(
                        'Cache Local de Dados',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Alunos salvos no cache local do SharedPreferences: $cachedCount registros.',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _clearCache,
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    label: const Text('Limpar Cache Local de Alunos', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4. SESSÃO DO USUÁRIO (Manter usuário logado)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      const Text(
                        'Sessão do Usuário (Persistência Ativa)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(authProv.user?.name ?? 'Não logado'),
                    subtitle: Text(authProv.user?.email ?? ''),
                    trailing: const Chip(
                      label: Text('Logado', style: TextStyle(color: Colors.white, fontSize: 11)),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await authProv.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/login');
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Encerrar Sessão (Logout)'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
