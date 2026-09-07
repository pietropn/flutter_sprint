import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/preferences_service.dart';
import 'services/academic_local_service.dart';
import 'providers/auth_provider.dart';
import 'providers/student_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/turma_provider.dart';
import 'providers/professor_provider.dart';
import 'providers/trabalho_provider.dart';
import 'providers/calendario_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o serviço de persistência local (SharedPreferences)
  await PreferencesService.instance.init();

  // Inicializa os dados acadêmicos locais (Turmas, Professores, Trabalhos,
  // Calendário), que a API do projeto ainda não expõe como endpoints.
  await AcademicLocalService.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => TurmaProvider()),
        ChangeNotifierProvider(create: (_) => ProfessorProvider()),
        ChangeNotifierProvider(create: (_) => TrabalhoProvider()),
        ChangeNotifierProvider(create: (_) => CalendarioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
