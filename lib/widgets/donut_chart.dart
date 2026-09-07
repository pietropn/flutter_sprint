import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Gráfico de rosca (donut) simples desenhado com CustomPainter, sem
/// dependências externas — usado nas telas de Turma e Dashboard para
/// mostrar Engajamento, Faltas e Entregas de Trabalho, como no protótipo.
class DonutChart extends StatelessWidget {
  final int percent; // 0-100
  final Color color;
  final String label;
  final double size;

  const DonutChart({
    super.key,
    required this.percent,
    required this.color,
    required this.label,
    this.size = 84,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _DonutPainter(percent: percent, color: color),
              ),
              Text(
                '$percent%',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final int percent;
  final Color color;
  _DonutPainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 10.0;

    final bg = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);
    canvas.drawArc(rect, 0, 2 * pi, false, bg);

    final sweep = 2 * pi * (percent.clamp(0, 100) / 100);
    canvas.drawArc(rect, -pi / 2, sweep, false, fg);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.color != color;
}
