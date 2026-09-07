import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'routes.dart';
import 'theme/app_theme.dart';
import 'pages/splash/splash_page.dart';
import 'widgets/main_shell.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Euro Tech!',
      debugShowCheckedModeBanner: false,
      themeMode: theme.themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routes: appRoutes,
      // Se a sessão estiver persistida no SharedPreferences, vai direto
      // para o shell principal (bottom nav); caso contrário, mostra a
      // tela inicial ("Página inicial mobile" do protótipo) com o botão
      // de login.
      home: auth.isLogged ? const MainShell() : const SplashPage(),
    );
  }
}
