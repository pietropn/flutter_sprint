import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Selo circular "Euro Tech!" usado no login e na splash, replicando o
/// ícone azul com "i" e destaque amarelo do protótipo.
class EuroTechLogo extends StatelessWidget {
  final double size;
  const EuroTechLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: size * 0.34,
          height: size * 0.34,
          decoration: const BoxDecoration(
            color: AppColors.accentYellow,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              'i',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w900,
                fontSize: size * 0.22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Wordmark "Euro Tech!" em azul, usado no topo das telas de conteúdo.
class EuroTechWordmark extends StatelessWidget {
  final double fontSize;
  const EuroTechWordmark({super.key, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Euro Tech!',
      style: TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
