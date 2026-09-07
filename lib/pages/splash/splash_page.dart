import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Réplica da tela "Página inicial mobile" do protótipo da Sprint 2:
/// fundo azul cheio, nome do app em destaque e botão para ir ao login.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Euro Tech!',
                style: TextStyle(
                  color: AppColors.accentYellow,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Você agora na sua instituição de ensino',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/login'),
                  child: const Text('FAZER LOGIN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
