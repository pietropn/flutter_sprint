import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Cartão com ícone acima do título (e subtítulo opcional abaixo),
/// usado para padronizar os atalhos e botões de ação tanto na Home do
/// Gestor quanto na Home do Professor.
class IconLabelCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final Color color;
  final Color background;
  final Color textColor;

  const IconLabelCard({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.color = AppColors.accentYellow,
    this.background = AppColors.primaryBlue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFD9DEE7)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor.withValues(alpha: 0.7), fontSize: 10),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
