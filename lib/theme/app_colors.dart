import 'package:flutter/material.dart';

/// Paleta de cores da identidade visual "Euro Tech!", extraída dos
/// protótipos apresentados na Sprint 2 (banners e navegação inferior
/// em azul-marinho, destaques em amarelo, cartões em branco).
class AppColors {
  AppColors._();

  static const Color primaryBlue = Color(0xFF123B7C);
  static const Color darkBlue = Color(0xFF0B2A57);
  static const Color lightBlue = Color(0xFF1E56A0);
  static const Color accentYellow = Color(0xFFFFC629);
  static const Color background = Color(0xFFF4F6FB);
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF16213A);
  static const Color textMuted = Color(0xFF6B7280);

  static const Color statusGreen = Color(0xFF2FA84F);
  static const Color statusOrange = Color(0xFFF2994A);
  static const Color statusRed = Color(0xFFE05353);
  static const Color statusBlueBadge = Color(0xFF3B82F6);

  // Cores usadas nos gráficos (donuts e barras)
  static const List<Color> chartPalette = [
    Color(0xFF123B7C),
    Color(0xFFFFC629),
    Color(0xFF2FA84F),
    Color(0xFF3B82F6),
    Color(0xFFE05353),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
  ];
}
