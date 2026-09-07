import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Etiqueta colorida de status ("Engajado", "Em risco", "Presente",
/// "Ausente", "Falta justificada"), conforme os protótipos.
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const StatusBadge({super.key, required this.text, required this.color});

  factory StatusBadge.fromEngajamento(String status) {
    final isRisco = status.toLowerCase().contains('risco');
    return StatusBadge(
      text: status,
      color: isRisco ? AppColors.statusRed : AppColors.statusGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
